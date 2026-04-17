import 'api_client.dart';

class WaterService {
  WaterService._();
  static final WaterService instance = WaterService._();

  final ApiClient _api = ApiClient.instance;

  /// [liters] o günün TOPLAM litre miktarıdır (increment değil). Backend aynı gün
  /// için upsert yapar; max 3 litre.
  Future<double> logWater(double liters, {String? date}) async {
    final data = await _api.mutate(
      r'''
      mutation LogWater($liters: Float!, $date: String) {
        logWater(liters: $liters, date: $date) { id date liters }
      }
      ''',
      variables: {'liters': liters, if (date != null) 'date': date},
    );
    return ((data['logWater'] as Map)['liters'] as num).toDouble();
  }

  Future<double> resetWater({String? date}) async {
    final data = await _api.mutate(
      r'''
      mutation ResetWater($date: String) {
        resetWater(date: $date) { id date liters }
      }
      ''',
      variables: {if (date != null) 'date': date},
    );
    return ((data['resetWater'] as Map)['liters'] as num).toDouble();
  }

  Future<List<Map<String, dynamic>>> waterLogs({
    int limit = 30,
    int offset = 0,
  }) async {
    final data = await _api.query(
      r'''
      query WaterLogs($limit: Int!, $offset: Int!) {
        waterLogs(limit: $limit, offset: $offset) { id date liters }
      }
      ''',
      variables: {'limit': limit, 'offset': offset},
    );
    final list = (data['waterLogs'] as List?) ?? const [];
    return list
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: false);
  }
}
