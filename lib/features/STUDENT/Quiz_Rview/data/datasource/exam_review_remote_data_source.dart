import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class ExamReviewRemoteDataSource {
  final Dio dio;

  ExamReviewRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getResult(String token, int attemptId) async {
    final String url =
        '${ApiConstants.baseUrl}/student/exams/attempts/$attemptId/result';

    print("📤 SENDING EXAM RESULT REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("📥 STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      return {"statusCode": response.statusCode, "data": response.data};
    } catch (e) {
      print("❌ DIO ERROR in getResult()");
      print("❌ DETAILS: $e");
      return {"statusCode": 0, "data": null};
    }
  }
}
