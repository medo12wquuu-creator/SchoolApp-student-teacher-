class RegisterResponse {
  final bool success;
  final String message;
  final String code;
  final int statusCode;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.code,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    final status = json['statusCode'] ?? 0;

    return RegisterResponse(
      success: status == 200 || status == 201,
      message: json['message'] ?? '',
      statusCode: status,
      code: json['code'].toString().trim(),
    );
  }
}
