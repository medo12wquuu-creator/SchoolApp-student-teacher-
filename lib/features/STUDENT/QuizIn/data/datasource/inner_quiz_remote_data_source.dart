import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class InnerQuizRemoteDataSource {
  final Dio dio;

  InnerQuizRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> startExam(String token, int examId) async {
    final String url = '${ApiConstants.baseUrl}/student/exams/$examId/start';

    print("📤 SENDING START EXAM REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("📥 STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      return {"statusCode": response.statusCode, "data": response.data};
    } catch (e) {
      print("❌ DIO ERROR in startExam()");
      print("❌ DETAILS: $e");
      return {"statusCode": 0, "data": null};
    }
  }

  Future<Map<String, dynamic>> submitAnswer({
    required String token,
    required int attemptId,
    required int questionId,
    required int optionId,
  }) async {
    final String url =
        '${ApiConstants.baseUrl}/student/exams/attempts/$attemptId/answer';

    print("📤 SENDING SUBMIT ANSWER REQUEST...");
    print("➡️ URL: $url");
    print("➡️ BODY: exam_question_id=$questionId, exam_option_id=$optionId");

    try {
      final response = await dio.post(
        url,
        data: {"exam_question_id": questionId, "exam_option_id": optionId},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("📥 STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      return {"statusCode": response.statusCode, "data": response.data};
    } catch (e) {
      print("❌ DIO ERROR in submitAnswer()");
      print("❌ DETAILS: $e");
      return {"statusCode": 0, "data": null};
    }
  }
  Future<Map<String, dynamic>> submitExam({
    required String token,
    required int attemptId,
  }) async {
    final String url =
        '${ApiConstants.baseUrl}/student/exams/attempts/$attemptId/submit';

    print("📤 SENDING SUBMIT EXAM REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("📥 STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      return {"statusCode": response.statusCode, "data": response.data};
    } catch (e) {
      print("❌ DIO ERROR in submitExam()");
      print("❌ DETAILS: $e");
      return {"statusCode": 0, "data": null};
    }
  }
}
