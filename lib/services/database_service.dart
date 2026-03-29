import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_analysis.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'kalori_tarayici.db');

    return openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
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
      },
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
    final maps = await db.query(
      'analyses',
      orderBy: 'analyzedAt DESC',
    );
    return maps.map((m) => FoodAnalysis.fromMap(m)).toList();
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

  /// Returns a list of maps with aggregated nutrition data for the last 7 days.
  /// Each map contains: date (String), calories, protein, carbs, fat (double).
  /// Days with no analyses are included with 0 values so the caller always gets
  /// exactly 7 entries ordered oldest → newest.
  Future<List<Map<String, dynamic>>> getWeeklyStats() async {
    final db = await database;
    final now = DateTime.now();

    // Build a list of the last 7 date strings (oldest first)
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

    final rows = await db.rawQuery('''
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

    // Index DB results by date for O(1) lookup
    final Map<String, Map<String, dynamic>> indexed = {
      for (final row in rows) row['date'] as String: row,
    };

    return dates.map((date) {
      if (indexed.containsKey(date)) {
        final row = indexed[date]!;
        return <String, dynamic>{
          'date': date,
          'calories': (row['calories'] as num?)?.toDouble() ?? 0.0,
          'protein': (row['protein'] as num?)?.toDouble() ?? 0.0,
          'carbs': (row['carbs'] as num?)?.toDouble() ?? 0.0,
          'fat': (row['fat'] as num?)?.toDouble() ?? 0.0,
        };
      }
      return <String, dynamic>{
        'date': date,
        'calories': 0.0,
        'protein': 0.0,
        'carbs': 0.0,
        'fat': 0.0,
      };
    }).toList();
  }

  /// Returns a list of maps with aggregated nutrition data for the last 30 days.
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

    final rows = await db.rawQuery('''
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

    final Map<String, Map<String, dynamic>> indexed = {
      for (final row in rows) row['date'] as String: row,
    };

    return dates.map((date) {
      if (indexed.containsKey(date)) {
        final row = indexed[date]!;
        return <String, dynamic>{
          'date': date,
          'calories': (row['calories'] as num?)?.toDouble() ?? 0.0,
          'protein': (row['protein'] as num?)?.toDouble() ?? 0.0,
          'carbs': (row['carbs'] as num?)?.toDouble() ?? 0.0,
          'fat': (row['fat'] as num?)?.toDouble() ?? 0.0,
        };
      }
      return <String, dynamic>{
        'date': date,
        'calories': 0.0,
        'protein': 0.0,
        'carbs': 0.0,
        'fat': 0.0,
      };
    }).toList();
  }

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

