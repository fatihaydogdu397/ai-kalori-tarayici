import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_sqlcipher/sqflite.dart';

/// EAT-141 — persistent FIFO queue for write mutations that failed due to
/// network errors. Items are replayed when connectivity is restored.
///
/// Scope (V1): only operations whose backend is already upsert-by-date are
/// whitelisted, so retries stay idempotent without a server-side request-id
/// column. Expanding the whitelist to `AnalyzeFood` / `SaveFoodAnalysis` /
/// `ToggleFavoriteMeal` needs backend idempotency support first (tracked
/// separately).
class QueuedMutation {
  QueuedMutation({
    required this.id,
    required this.operationName,
    required this.document,
    required this.variablesJson,
    required this.createdAt,
    required this.retryCount,
    this.lastError,
  });

  final int id;
  final String operationName;
  final String document;
  final String variablesJson;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;

  Map<String, dynamic> get variables =>
      Map<String, dynamic>.from(jsonDecode(variablesJson) as Map);
}

class MutationQueue {
  MutationQueue._();
  static final MutationQueue instance = MutationQueue._();

  static const _secureStorage = FlutterSecureStorage();
  static const _keyStorageName = 'eatiq_db_key_v1';
  static const _dbFile = 'eatiq_queue.db';

  static const int maxRetries = 5;
  static const int maxQueueLength = 100;
  static const Duration maxAge = Duration(days: 7);

  static const Set<String> whitelistedOperations = {
    'LogWater',
    'LogWeight',
  };

  static bool isWhitelisted(String? operationName) =>
      operationName != null && whitelistedOperations.contains(operationName);

  Database? _db;

  Future<Database> _open() async {
    if (_db != null) return _db!;
    final dir = await getDatabasesPath();
    final path = p.join(dir, _dbFile);
    final key = await _getOrCreateKey();
    _db = await openDatabase(
      path,
      password: key,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE pending_mutations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            operationName TEXT NOT NULL,
            document TEXT NOT NULL,
            variablesJson TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            retryCount INTEGER NOT NULL DEFAULT 0,
            lastError TEXT
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_pending_created ON pending_mutations(createdAt)',
        );
      },
    );
    return _db!;
  }

  Future<String> _getOrCreateKey() async {
    final existing = await _secureStorage.read(key: _keyStorageName);
    if (existing != null && existing.isNotEmpty) return existing;
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    final key = base64Encode(bytes);
    await _secureStorage.write(key: _keyStorageName, value: key);
    return key;
  }

  Future<int> enqueue({
    required String operationName,
    required String document,
    required Map<String, dynamic> variables,
  }) async {
    final db = await _open();
    await _trimIfOverflow(db);
    return db.insert('pending_mutations', {
      'operationName': operationName,
      'document': document,
      'variablesJson': jsonEncode(variables),
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'retryCount': 0,
    });
  }

  Future<void> _trimIfOverflow(Database db) async {
    final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM pending_mutations'),
        ) ??
        0;
    if (count < maxQueueLength) return;
    final toRemove = count - maxQueueLength + 1;
    await db.rawDelete(
      'DELETE FROM pending_mutations WHERE id IN '
      '(SELECT id FROM pending_mutations ORDER BY createdAt ASC LIMIT ?)',
      [toRemove],
    );
  }

  Future<List<QueuedMutation>> pending({int limit = 50}) async {
    final db = await _open();
    final rows = await db.query(
      'pending_mutations',
      orderBy: 'createdAt ASC',
      limit: limit,
    );
    return rows
        .map((r) => QueuedMutation(
              id: r['id'] as int,
              operationName: r['operationName'] as String,
              document: r['document'] as String,
              variablesJson: r['variablesJson'] as String,
              createdAt: DateTime.parse(r['createdAt'] as String),
              retryCount: r['retryCount'] as int,
              lastError: r['lastError'] as String?,
            ))
        .toList(growable: false);
  }

  Future<int> pendingCount() async {
    final db = await _open();
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM pending_mutations'),
        ) ??
        0;
  }

  Future<void> markSuccess(int id) async {
    final db = await _open();
    await db.delete('pending_mutations', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markFailed(int id, String error) async {
    final db = await _open();
    final rows = await db.query(
      'pending_mutations',
      columns: ['retryCount'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return;
    final current = rows.first['retryCount'] as int;
    if (current + 1 >= maxRetries) {
      await db.delete('pending_mutations', where: 'id = ?', whereArgs: [id]);
      return;
    }
    await db.update(
      'pending_mutations',
      {'retryCount': current + 1, 'lastError': error},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> purgeOld() async {
    final db = await _open();
    final cutoff = DateTime.now().toUtc().subtract(maxAge).toIso8601String();
    await db.delete(
      'pending_mutations',
      where: 'createdAt < ?',
      whereArgs: [cutoff],
    );
  }
}
