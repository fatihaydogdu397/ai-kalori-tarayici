import '../../models/blood_test.dart';
import 'api_client.dart';

/// Backend `BloodTest` endpoint'lerini saran servis.
///
/// Upload akışı:
/// - FE dosyayı (PDF veya image) base64'e çevirir, mime type'ı belirler
///   ve `uploadBloodTest` mutation'ına gönderir.
/// - BE R2'ye yükler + AI pipeline'ı PENDING/COMPLETED/FAILED durumunu
///   arkaplanda günceller; FE tekrar `myBloodTests` ile polling yapabilir
///   ama MVP için tek seferlik refresh yeterli.
class BloodTestService {
  BloodTestService._();
  static final BloodTestService instance = BloodTestService._();

  final ApiClient _api = ApiClient.instance;

  static const String _fields = '''
    id fileUrl status testDate errorMessage createdAt updatedAt
  ''';

  Future<BloodTest> upload({
    required String base64,
    required String mimeType,
    String? testDate,
  }) async {
    final input = <String, dynamic>{
      'base64': base64,
      'mimeType': mimeType,
    };
    if (testDate != null && testDate.isNotEmpty) {
      input['testDate'] = testDate;
    }

    final data = await _api.mutate(
      '''
      mutation UploadBloodTest(\$input: UploadBloodTestInput!) {
        uploadBloodTest(input: \$input) { $_fields }
      }
      ''',
      variables: {'input': input},
    );
    return BloodTest.fromBackend(
      Map<String, dynamic>.from(data['uploadBloodTest'] as Map),
    );
  }

  Future<List<BloodTest>> list({int limit = 20, int offset = 0}) async {
    final data = await _api.query(
      '''
      query MyBloodTests(\$limit: Int, \$offset: Int) {
        myBloodTests(limit: \$limit, offset: \$offset) { $_fields }
      }
      ''',
      variables: {'limit': limit, 'offset': offset},
    );
    final raw = (data['myBloodTests'] as List?) ?? const [];
    return raw
        .map((e) => BloodTest.fromBackend(Map<String, dynamic>.from(e as Map)))
        .toList(growable: false);
  }

  Future<BloodTest> get(String id) async {
    final data = await _api.query(
      '''
      query BloodTest(\$id: ID!) {
        bloodTest(id: \$id) { $_fields }
      }
      ''',
      variables: {'id': id},
    );
    return BloodTest.fromBackend(
      Map<String, dynamic>.from(data['bloodTest'] as Map),
    );
  }

  Future<bool> delete(String id) async {
    final data = await _api.mutate(
      r'''
      mutation DeleteBloodTest($id: ID!) {
        deleteBloodTest(id: $id)
      }
      ''',
      variables: {'id': id},
    );
    return data['deleteBloodTest'] == true;
  }
}
