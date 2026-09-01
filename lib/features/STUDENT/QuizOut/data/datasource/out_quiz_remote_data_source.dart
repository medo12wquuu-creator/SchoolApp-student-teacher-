import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class OutQuizRemoteDataSource {
  final Dio dio;

  OutQuizRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getExams(String token) async {
    final String url = '${ApiConstants.baseUrl}${EndPoints.outquiz}';

    print("📤 SENDING EXAMS REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("📥 STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      final data = response.data;
      List<dynamic> quizzes = [];

      if (data is Map) {
        final inner = data["data"];
        if (inner is Map && inner["data"] is List) {
          quizzes = inner["data"];
        } else if (inner is List) {
          quizzes = inner;
        }
      } else if (data is List) {
        quizzes = data;
      }

      return {"statusCode": response.statusCode, "quizzes": quizzes};
    } catch (e) {
      print("❌ DIO ERROR in getExams()");
      print("❌ DETAILS: $e");
      return {"statusCode": 0, "quizzes": []};
    }
  }
}
