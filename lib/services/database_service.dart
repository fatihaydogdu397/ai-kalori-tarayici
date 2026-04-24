import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart';
import '../models/food_analysis.dart';

class DatabaseService {
  static Database? _database;

  // EAT-124 2d: encryption key lives in Keychain (iOS) / encrypted Keystore (Android).
  // Generated once per install; survives app kills, wiped on uninstall.
  static const _secureStorage = FlutterSecureStorage();
  static const _keyStorageName = 'eatiq_db_key_v1';
  static const _migrationFlag = 'db_encrypted_v1';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<String> _getOrCreateEncryptionKey() async {
    final existing = await _secureStorage.read(key: _keyStorageName);
    if (existing != null && existing.isNotEmpty) return existing;
    // 256-bit random key, base64-encoded for SQLCipher's password param.
    final rng = Random.secure();
    final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
    final key = base64Encode(bytes);
    await _secureStorage.write(key: _keyStorageName, value: key);
    return key;
  }

  /// One-time migration: if a plaintext `kalori_tarayici.db` exists from a pre-2d
  /// install, copy rows into a fresh encrypted DB and delete the plaintext file.
  /// Guarded by a SharedPreferences flag so it runs at most once.
  Future<void> _migratePlaintextIfNeeded(String path, String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_migrationFlag) ?? false) return;

    final file = File(path);
    if (!file.existsSync()) {
      await prefs.setBool(_migrationFlag, true);
      return;
    }

    // Try to open the file as plaintext. If it's already encrypted (fresh
    // install of 2d version), the open will fail or read garbage — in that
    // case we just mark migration complete without touching the file.
    Database? old;
    try {
      old = await openDatabase(path, readOnly: true);
      final analyses = await old.query('analyses');
      final water = await old.query('water_log');
      final weight = await old.query('weight_log');
      await old.close();

      await file.delete();

      final fresh = await openDatabase(
        path,
        password: key,
        version: 5,
        onCreate: _createSchema,
      );
      final batch = fresh.batch();
      for (final row in analyses) {
        batch.insert('analyses', row);
      }
      for (final row in water) {
        batch.insert('water_log', row);
      }
      for (final row in weight) {
        batch.insert('weight_log', row);
      }
      await batch.commit(noResult: true);
      await fresh.close();
    } catch (_) {
      // Plaintext open failed → either file is corrupt or already encrypted.
      // Either way, don't lose data: leave the file untouched so a subsequent
      // openDatabase(password: key) either succeeds or fails loudly.
      try {
        await old?.close();
      } catch (_) {}
    }

    await prefs.setBool(_migrationFlag, true);
  }

  Future<void> _createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE analyses (
        id TEXT PRIMARY KEY,
        imagePath TEXT NOT NULL,
        summary TEXT,
        advice TEXT,
        analyzedAt TEXT NOT NULL,
        totalCalories REAL,
        totalProtein REAL,
        totalCarbs REAL,
        totalFat REAL,
        totalFiber REAL,
        totalSugar REAL,
        mealCategory TEXT,
        isFavorite INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS water_log (
        id TEXT,
        date TEXT,
        liters REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS weight_log (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        weight REAL NOT NULL
      )
    ''');
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'kalori_tarayici.db');
    final key = await _getOrCreateEncryptionKey();

    await _migratePlaintextIfNeeded(path, key);

    return openDatabase(
      path,
      password: key,
      version: 5,
      onCreate: _createSchema,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS water_log (
              id TEXT,
              date TEXT,
              liters REAL
            )
          ''');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE analyses ADD COLUMN mealCategory TEXT');
        }
        if (oldVersion < 4) {
          await db.execute('ALTER TABLE analyses ADD COLUMN isFavorite INTEGER DEFAULT 0');
        }
        if (oldVersion < 5) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS weight_log (
              id TEXT PRIMARY KEY,
              date TEXT NOT NULL,
              weight REAL NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<void> saveAnalysis(FoodAnalysis analysis) async {
    final db = await database;
    await db.insert(
      'analyses',
      analysis.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FoodAnalysis>> getAllAnalyses() async {
    final db = await database;
    final maps = await db.query('analyses', orderBy: 'analyzedAt DESC');
    final appDir = await getApplicationDocumentsDirectory();
    final docsPath = appDir.path;

    return maps.map((m) {
      final analysis = FoodAnalysis.fromMap(m);
      final stored = analysis.imagePath;

      // Sadece dosya adı kaydedilmişse (yeni format) → tam yolu ekle
      if (!stored.startsWith('/')) {
        return analysis.copyWith(imagePath: p.join(docsPath, stored));
      }

      // Tam path kaydedilmiş ama UUID değişmiş → basename'den yeniden çöz
      if (!File(stored).existsSync()) {
        final filename = p.basename(stored);
        if (filename.isNotEmpty) {
          final resolved = p.join(docsPath, filename);
          if (File(resolved).existsSync()) {
            return analysis.copyWith(imagePath: resolved);
          }
        }
      }

      return analysis;
    }).toList();
  }

  Future<void> deleteAnalysis(String id) async {
    final db = await database;
    await db.delete('analyses', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> setFavorite(String id, bool isFavorite) async {
    final db = await database;
    await db.update('analyses', {'isFavorite': isFavorite ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, double>> getTodayStats() async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay =
        DateTime(today.year, today.month, today.day).toIso8601String();
    final endOfDay =
        DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();

    final result = await db.rawQuery('''
      SELECT
        SUM(totalCalories) as calories,
        SUM(totalProtein) as protein,
        SUM(totalCarbs) as carbs,
        SUM(totalFat) as fat
      FROM analyses
      WHERE analyzedAt BETWEEN ? AND ?
    ''', [startOfDay, endOfDay]);

    if (result.isNotEmpty && result[0]['calories'] != null) {
      return {
        'calories': (result[0]['calories'] as num).toDouble(),
        'protein': (result[0]['protein'] as num).toDouble(),
        'carbs': (result[0]['carbs'] as num).toDouble(),
        'fat': (result[0]['fat'] as num).toDouble(),
      };
    }
    return {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0};
  }

  // ---------------------------------------------------------------------------
  // Water tracking
  // ---------------------------------------------------------------------------

  /// Saves or updates today's total water intake.
  /// Uses an upsert strategy: deletes the existing row for today, then inserts
  /// the new cumulative value so the total is always a single row per day.
  Future<void> saveWater(double liters, DateTime date) async {
    final db = await database;
    final dateStr = '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    await db.delete('water_log', where: 'date = ?', whereArgs: [dateStr]);
    await db.insert('water_log', {
      'id': dateStr,
      'date': dateStr,
      'liters': liters,
    });
  }

  /// Returns today's total water intake in liters (0.0 if none recorded).
  Future<double> getTodayWater() async {
    final db = await database;
    final today = DateTime.now();
    final dateStr = '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    final result = await db.query(
      'water_log',
      where: 'date = ?',
      whereArgs: [dateStr],
      limit: 1,
    );

    if (result.isNotEmpty && result[0]['liters'] != null) {
      return (result[0]['liters'] as num).toDouble();
    }
    return 0.0;
  }

  // ---------------------------------------------------------------------------
  // Weekly stats
  // ---------------------------------------------------------------------------

  /// Returns a list of maps with aggregated nutrition and water data for the last 7 days.
  Future<List<Map<String, dynamic>>> getWeeklyStats() async {
    final db = await database;
    final now = DateTime.now();

    final dates = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
    });

    final startOfRange =
        DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
    final endOfRange =
        DateTime(now.year, now.month, now.day, 23, 59, 59);

    final mealRows = await db.rawQuery('''
      SELECT
        SUBSTR(analyzedAt, 1, 10) as date,
        SUM(totalCalories) as calories,
        SUM(totalProtein) as protein,
        SUM(totalCarbs) as carbs,
        SUM(totalFat) as fat
      FROM analyses
      WHERE analyzedAt BETWEEN ? AND ?
      GROUP BY SUBSTR(analyzedAt, 1, 10)
    ''', [startOfRange.toIso8601String(), endOfRange.toIso8601String()]);

    final waterRows = await db.rawQuery('''
      SELECT date, liters FROM water_log
      WHERE date BETWEEN ? AND ?
    ''', [dates.first, dates.last]);

    final Map<String, Map<String, dynamic>> mealIndexed = {
      for (final row in mealRows) row['date'] as String: row,
    };
    final Map<String, double> waterIndexed = {
      for (final row in waterRows) row['date'] as String: (row['liters'] as num).toDouble(),
    };

    return dates.map((date) {
      final meal = mealIndexed[date];
      return <String, dynamic>{
        'date': date,
        'calories': (meal?['calories'] as num?)?.toDouble() ?? 0.0,
        'protein': (meal?['protein'] as num?)?.toDouble() ?? 0.0,
        'carbs': (meal?['carbs'] as num?)?.toDouble() ?? 0.0,
        'fat': (meal?['fat'] as num?)?.toDouble() ?? 0.0,
        'water': waterIndexed[date] ?? 0.0,
      };
    }).toList();
  }

  /// Returns a list of maps with aggregated nutrition and water data for the last 30 days.
  Future<List<Map<String, dynamic>>> getMonthlyStats() async {
    final db = await database;
    final now = DateTime.now();

    final dates = List.generate(30, (i) {
      final d = now.subtract(Duration(days: 29 - i));
      return '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
    });

    final startOfRange =
        DateTime(now.year, now.month, now.day).subtract(const Duration(days: 29));
    final endOfRange =
        DateTime(now.year, now.month, now.day, 23, 59, 59);

    final mealRows = await db.rawQuery('''
      SELECT
        SUBSTR(analyzedAt, 1, 10) as date,
        SUM(totalCalories) as calories,
        SUM(totalProtein) as protein,
        SUM(totalCarbs) as carbs,
        SUM(totalFat) as fat
      FROM analyses
      WHERE analyzedAt BETWEEN ? AND ?
      GROUP BY SUBSTR(analyzedAt, 1, 10)
    ''', [startOfRange.toIso8601String(), endOfRange.toIso8601String()]);

    final waterRows = await db.rawQuery('''
      SELECT date, liters FROM water_log
      WHERE date BETWEEN ? AND ?
    ''', [dates.first, dates.last]);

    final Map<String, Map<String, dynamic>> mealIndexed = {
      for (final row in mealRows) row['date'] as String: row,
    };
    final Map<String, double> waterIndexed = {
      for (final row in waterRows) row['date'] as String: (row['liters'] as num).toDouble(),
    };

    return dates.map((date) {
      final meal = mealIndexed[date];
      return <String, dynamic>{
        'date': date,
        'calories': (meal?['calories'] as num?)?.toDouble() ?? 0.0,
        'protein': (meal?['protein'] as num?)?.toDouble() ?? 0.0,
        'carbs': (meal?['carbs'] as num?)?.toDouble() ?? 0.0,
        'fat': (meal?['fat'] as num?)?.toDouble() ?? 0.0,
        'water': waterIndexed[date] ?? 0.0,
      };
    }).toList();
  }

  /// Returns the most consumed meal category (by calories) in the last [days] days.
  Future<String?> getTopMealCategory(int days) async {
    final db = await database;
    final now = DateTime.now();
    final startOfRange = DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));

    final result = await db.rawQuery('''
      SELECT mealCategory, SUM(totalCalories) as total
      FROM analyses
      WHERE analyzedAt >= ?
      GROUP BY mealCategory
      ORDER BY total DESC
      LIMIT 1
    ''', [startOfRange.toIso8601String()]);

    if (result.isNotEmpty) return result.first['mealCategory'] as String?;
    return null;
  }

  // --- KİLO METOTLARI ---

  // --- KİLO METOTLARI ---
  Future<void> saveWeight(double weight, DateTime date) async {
    final db = await database;
    // Aynı güne kaydedilmiş veri varsa, onu ezelim (saat, dakika kırparak aynı gün yapalım)
    final dateString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T00:00:00.000";
    
    // Check if exists
    final existing = await db.query('weight_log', where: 'date = ?', whereArgs: [dateString]);
    if (existing.isNotEmpty) {
      await db.update('weight_log', {'weight': weight}, where: 'date = ?', whereArgs: [dateString]);
    } else {
      await db.insert('weight_log', {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'date': dateString,
        'weight': weight,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getWeightLogs() async {
    final db = await database;
    return await db.query('weight_log', orderBy: 'date ASC');
  }
}

