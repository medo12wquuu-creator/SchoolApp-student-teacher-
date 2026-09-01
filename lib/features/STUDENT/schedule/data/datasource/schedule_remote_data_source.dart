import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class ScheduleRemoteDataSource {
  final Dio dio;

  ScheduleRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getSchedule(String token) async {
    final url = '${ApiConstants.baseUrl}${EndPoints.schedule}';

    print("📤 SENDING SCHEDULE REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            // "Content-Type": "application/json",
          },
        ),
      );

      print("📥 RESPONSE RECEIVED:");
      print("➡️ STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      final schedulePayload =
          response.data["schedule"] ??
          response.data["lessons"] ??
          response.data;

      return {
        "statusCode": response.statusCode,
        "schedule": schedulePayload is List ? schedulePayload : [],
      };
    } catch (e) {
      print("❌ DIO ERROR in getSchedule()");
      print("❌ DETAILS: $e");

      return {"statusCode": 0, "schedule": []};
    }
  }
}
