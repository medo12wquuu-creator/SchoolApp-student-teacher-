class Register2Response {
  final bool success;
  final String message;
  final int statusCode;

  Register2Response({
    required this.success,
    required this.message,
    required this.statusCode,
  });

  factory Register2Response.fromJson(Map<String, dynamic> json) {
    final status = json["statusCode"] ?? 0;

    return Register2Response(
      success: status == 200 || status == 201,
      message: json["message"] ?? "",
      statusCode: status,
    );
  }
}
