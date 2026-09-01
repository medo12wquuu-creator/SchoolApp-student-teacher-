class QrResponse {
  final bool success;
  final String message;
  final String status;

  QrResponse({
    required this.success,
    required this.message,
    required this.status,
  });

  factory QrResponse.fromJson(Map<String, dynamic> json) {
    return QrResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      status: json["status"] ?? "0",
    );
  }
}
