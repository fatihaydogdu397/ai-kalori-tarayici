import 'api_client.dart';

class WeightService {
  WeightService._();
  static final WeightService instance = WeightService._();

  final ApiClient _api = ApiClient.instance;

  Future<Map<String, dynamic>> logWeight(double weight, {String? date}) async {
    final data = await _api.mutate(
      r'''
      mutation LogWeight($weight: Float!, $date: String) {
        logWeight(weight: $weight, date: $date) { id date weight }
      }
      ''',
      variables: {'weight': weight, if (date != null) 'date': date},
    );
    return Map<String, dynamic>.from(data['logWeight'] as Map);
  }

  Future<List<Map<String, dynamic>>> weightLogs({
    int limit = 30,
    int offset = 0,
  }) async {
    final data = await _api.query(
      r'''
      query WeightLogs($limit: Int!, $offset: Int!) {
        weightLogs(limit: $limit, offset: $offset) { id date weight }
      }
      ''',
      variables: {'limit': limit, 'offset': offset},
    );
    final list = (data['weightLogs'] as List?) ?? const [];
    return list
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: false);
  }
}
