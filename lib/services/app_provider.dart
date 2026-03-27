import 'package:flutter/foundation.dart';
import '../models/food_analysis.dart';
import 'claude_service.dart';
import 'database_service.dart';

enum AnalysisState { idle, loading, success, error }

class AppProvider extends ChangeNotifier {
  final _claudeService = ClaudeService();
  final _dbService = DatabaseService();

  AnalysisState _state = AnalysisState.idle;
  FoodAnalysis? _currentAnalysis;
  List<FoodAnalysis> _history = [];
  Map<String, double> _todayStats = {};
  String _errorMessage = '';
  double _dailyCalorieGoal = 2000;

  AnalysisState get state => _state;
  FoodAnalysis? get currentAnalysis => _currentAnalysis;
  List<FoodAnalysis> get history => _history;
  Map<String, double> get todayStats => _todayStats;
  String get errorMessage => _errorMessage;
  double get dailyCalorieGoal => _dailyCalorieGoal;

  double get todayCalories => _todayStats['calories'] ?? 0;
  double get calorieProgress =>
      (todayCalories / _dailyCalorieGoal).clamp(0.0, 1.0);

  Future<void> analyzeImage(String imagePath) async {
    _state = AnalysisState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final analysis = await _claudeService.analyzeFood(imagePath);
      _currentAnalysis = analysis;
      await _dbService.saveAnalysis(analysis);
      await loadHistory();
      await loadTodayStats();
      _state = AnalysisState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AnalysisState.error;
    }

    notifyListeners();
  }

  Future<void> loadHistory() async {
    _history = await _dbService.getAllAnalyses();
    notifyListeners();
  }

  Future<void> loadTodayStats() async {
    _todayStats = await _dbService.getTodayStats();
    notifyListeners();
  }

  Future<void> deleteAnalysis(String id) async {
    await _dbService.deleteAnalysis(id);
    await loadHistory();
    await loadTodayStats();
  }

  void resetState() {
    _state = AnalysisState.idle;
    _currentAnalysis = null;
    notifyListeners();
  }

  void setCalorieGoal(double goal) {
    _dailyCalorieGoal = goal;
    notifyListeners();
  }
}
