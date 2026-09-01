import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class TasksRemoteDataSource {
  final Dio dio;

  TasksRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getTasks(String token) async {
    final url = '${ApiConstants.baseUrl}${EndPoints.allTasks}';

    print("📤 SENDING TASKS REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("📥 RESPONSE RECEIVED:");
      print("➡️ STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      final data = response.data;
      List<dynamic> tasks = [];
      if (data is List) {
        tasks = data;
      } else if (data is Map) {
        tasks = data["tasks"] ?? data["tomorrow_tasks"] ?? [];
      }

      return {"statusCode": response.statusCode, "tasks": tasks};
    } catch (e) {
      print("❌ DIO ERROR in getTasks()");
      print("❌ DETAILS: $e");

      return {"statusCode": 0, "tasks": []};
    }
  }
}
