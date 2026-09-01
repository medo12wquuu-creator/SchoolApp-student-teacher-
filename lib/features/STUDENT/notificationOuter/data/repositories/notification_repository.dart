import 'package:schooly/features/STUDENT/notificationOuter/data/datasoucre/notification_remote_data_source.dart';
import '../model/notification_model.dart';

class NotificationRepository {
  final NotificationRemoteDataSource _remote;

  NotificationRepository(this._remote);

  Future<void> sendTokenToServer(String fcmToken, String authToken) {
    return _remote.sendTokenToServer(fcmToken, authToken);
  }

  Future<List<NotificationModel>> getNotifications(String authToken) {
    return _remote.getNotifications(authToken);
  }

  Future<int> getUnreadCount(String authToken) {
    return _remote.getUnreadCount(authToken);
  }

  Future<void> markAllRead(String authToken) {
    return _remote.markAllRead(authToken);
  }

  Future<void> deleteNotification(String notificationId, String authToken) {
    return _remote.deleteNotification(notificationId, authToken);
  }
}
