import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class AnnouncementsRemoteDataSource {
  final Dio dio;

  AnnouncementsRemoteDataSource(this.dio);

  Future<List<dynamic>> getAnnouncements(String token) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${EndPoints.announcement}',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data["announcements"] as List<dynamic>;
  }
}
