import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class NoteTeacherRemoteDataSource {
  final Dio dio;

  NoteTeacherRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> fetchNotes(String token) async {
    final url = '${ApiConstants.baseUrl}${EndPoints.notes}';

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      }
      print(
        "fffff🎈🎆fffffffffffffkkkkkkkkkkkkkkkkkkkkkfffffffffffffffffkkkkkkkkkkkkkk",
      );
      print(response.data);
      return {};
    } catch (e) {
      rethrow;
    }
  }
}
