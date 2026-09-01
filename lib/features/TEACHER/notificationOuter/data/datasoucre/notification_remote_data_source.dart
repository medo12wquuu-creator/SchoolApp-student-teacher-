import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';
import '../model/notification_model.dart';

class NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSource(this.dio);

  Future<void> sendTokenToServer(String fcmToken, String authToken) async {
    await dio.post(
      "${ApiConstants.baseUrl}/fcm-token",
      data: {'fcm_token': fcmToken},
      options: Options(headers: {'Authorization': 'Bearer $authToken'}),
    );
  }

  Future<List<NotificationModel>> getNotifications(String authToken) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${EndPoints.notifications}',
      options: Options(headers: {'Authorization': 'Bearer $authToken'}),
    );

    final data = response.data['notifications'] as List? ?? const [];
    return data
        .map(
          (item) => NotificationModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  Future<int> getUnreadCount(String authToken) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${EndPoints.unreadNotificationsCount}',
      options: Options(headers: {'Authorization': 'Bearer $authToken'}),
    );

    return (response.data['unread_count'] as num?)?.toInt() ?? 0;
  }

  Future<void> markAllRead(String authToken) async {
    await dio.post(
      '${ApiConstants.baseUrl}${EndPoints.readAllNotifications}',
      options: Options(headers: {'Authorization': 'Bearer $authToken'}),
    );
  }

  Future<void> deleteNotification(
    String notificationId,
    String authToken,
  ) async {
    await dio.delete(
      '${ApiConstants.baseUrl}${EndPoints.notifications}/$notificationId',
      options: Options(headers: {'Authorization': 'Bearer $authToken'}),
    );
  }
}
