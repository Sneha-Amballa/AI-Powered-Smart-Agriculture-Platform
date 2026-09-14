/// Domain-friendly network and API exception class.
class ApiException implements Exception {
  final String userMessage;
  final String? technicalDetail;
  final int? statusCode;

  ApiException({
    required this.userMessage,
    this.technicalDetail,
    this.statusCode,
  });

  factory ApiException.networkError([String? detail]) {
    return ApiException(
      userMessage: 'Unable to connect to the server. Please check your internet connection.',
      technicalDetail: detail,
    );
  }

  factory ApiException.timeout() {
    return ApiException(
      userMessage: 'Request timed out. The server might be waking up or busy, please try again shortly.',
      statusCode: 408,
    );
  }

  factory ApiException.serverError([int? code, String? detail]) {
    return ApiException(
      userMessage: 'A server error occurred. Please try again in a few moments.',
      statusCode: code ?? 500,
      technicalDetail: detail,
    );
  }

  factory ApiException.clientError(int code, String message) {
    return ApiException(
      userMessage: message,
      statusCode: code,
    );
  }

  @override
  String toString() =>
      'ApiException(status: $statusCode, message: $userMessage, detail: $technicalDetail)';
}
