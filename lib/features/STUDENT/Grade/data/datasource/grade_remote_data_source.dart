import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class GradeRemoteDataSource {
  final Dio dio;

  GradeRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getGrade(String token) async {
    final url = '${ApiConstants.baseUrl}${EndPoints.grade}';
    print('========== GradeRemoteDataSource.getGrade ==========');
    print('URL: $url');

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
      print('Status code: ${response.statusCode}');
      print('Response: $response.data');

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      }

      return {};
    } catch (e) {
      print('GradeRemoteDataSource error: $e');
      rethrow;
    }
  }
}
