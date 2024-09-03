class ApiResponse {
  final int statusCode;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.statusCode,
    required this.message,
    this.data,
  });
}
