class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, dynamic>? extensions;

  ApiException(this.message, {this.code, this.statusCode, this.extensions});

  bool get isUnauthenticated =>
      statusCode == 401 ||
      code == 'UNAUTHENTICATED' ||
      code == 'FORBIDDEN';

  bool get isNetwork => code == 'NETWORK_ERROR';

  @override
  String toString() => 'ApiException($code $statusCode): $message';
}
