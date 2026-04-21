/// Backend `BloodTest` entity'sinin FE karşılığı.
///
/// BE status alanı küçük harf ('pending' | 'completed' | 'failed') gelir,
/// FE'de aynı string korunur — UI katmanı switch ile lokalize bir etiket
/// gösterir.
enum BloodTestStatus { pending, completed, failed }

BloodTestStatus _parseStatus(String? raw) {
  switch (raw?.toLowerCase()) {
    case 'completed':
      return BloodTestStatus.completed;
    case 'failed':
      return BloodTestStatus.failed;
    case 'pending':
    default:
      return BloodTestStatus.pending;
  }
}

class BloodTest {
  final String id;
  final String fileUrl;
  final BloodTestStatus status;
  final String? testDate; // YYYY-MM-DD
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BloodTest({
    required this.id,
    required this.fileUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.testDate,
    this.errorMessage,
  });

  factory BloodTest.fromBackend(Map<String, dynamic> map) {
    return BloodTest(
      id: (map['id'] ?? '') as String,
      fileUrl: (map['fileUrl'] ?? '') as String,
      status: _parseStatus(map['status'] as String?),
      testDate: map['testDate'] as String?,
      errorMessage: map['errorMessage'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
