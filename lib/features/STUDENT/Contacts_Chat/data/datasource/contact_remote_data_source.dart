import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class ContactRemoteDataSource {
  final Dio dio;

  ContactRemoteDataSource(this.dio);

  Future<List<dynamic>> getContacts(String token) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${EndPoints.chatcontacts}',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] is List) {
      return List<dynamic>.from(data['data']);
    }

    if (data is Map && data['data'] is List) {
      return List<dynamic>.from(data['data']);
    }

    return [];
  }
}
