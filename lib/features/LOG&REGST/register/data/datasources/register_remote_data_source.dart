import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class RegisterRemoteDataSource {
  final Dio dio;

  RegisterRemoteDataSource(this.dio) {
    // إضافة timeout
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) async {
    final url = ApiConstants.baseUrl + EndPoints.register1;
    print("📤 SENDING REGISTER REQUEST...");
    print("➡️ URL: $url");
    print("➡️ BODY: $body");

    try {
      final response = await dio.post(url, data: body);

      print("📥 RESPONSE RECEIVED:");
      print("➡️ STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");
      print("➡️ STATUS MESSAGE: ${response.statusMessage}");

      String message = response.statusMessage ?? '';

      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('message')) {
        message = response.data['message']?.toString() ?? message;
      }

      print("📌 FINAL MESSAGE: $message");
      print("📌 FINAL CODE: ${response.data["user"]["code"] ?? ''}");

      return {
        "statusCode": response.statusCode,
        "message": message,
        "code": response.data["user"]["code"] ?? '',
      };
    } catch (e) {
      print("❌ DIO ERROR:");
      print(e);

      return {"statusCode": 0, "message": "Connection failed: $e"};
    }
  }
}
