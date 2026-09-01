import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class OutChatRemoteDataSource {
  final Dio dio;

  OutChatRemoteDataSource(this.dio);

  Future<List<dynamic>> getConversations(String token) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${EndPoints.chatout}',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data['conversations'] as List<dynamic>;
  }
}
