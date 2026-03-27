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
      version: 1,
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
            totalSugar REAL
          )
        ''');
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
}
