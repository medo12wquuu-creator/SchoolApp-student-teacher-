import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSource(this.dio);

  /// جلب كل المحادثات الخاصة بالمستخدم
  Future<List<dynamic>> loadConversations(String token) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${EndPoints.chat}',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data as List<dynamic>;
  }

  /// جلب الرسائل داخل محادثة موجودة
  Future<List<dynamic>> loadMessages(int conversationId, String token) async {
    final response = await dio.get(
      'https://diving-settle-careless.ngrok-free.dev/api/chat/conversations/$conversationId/messages',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data as List<dynamic>;
  }

  /// إرسال رسالة (أول رسالة أو داخل محادثة موجودة)
  Future<Map<String, dynamic>> sendMessage(
    Map<String, dynamic> body,
    String token,
  ) async {
    final response = await dio.post(
      'https://diving-settle-careless.ngrok-free.dev/api/chat/send',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data as Map<String, dynamic>;
  }

  /// تعليم الرسائل كمقروءة
  Future<Map<String, dynamic>> markAsRead(
    int conversationId,
    String token,
  ) async {
    final response = await dio.post(
      'https://diving-settle-careless.ngrok-free.dev/api/chat/conversations/$conversationId/read',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data as Map<String, dynamic>;
  }
}
