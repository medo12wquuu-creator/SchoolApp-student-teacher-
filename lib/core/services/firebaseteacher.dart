import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:schooly/core/services/firebase_options.dart';
import 'package:schooly/features/TEACHER/notificationOuter/data/datasoucre/notification_remote_data_source.dart';
import 'package:schooly/features/TEACHER/notificationOuter/data/model/notification_model.dart';
import 'package:schooly/features/TEACHER/notificationOuter/data/repositories/notification_repository.dart';

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("BG Notification: ${message.notification?.title}");
}

class FirebaseNotificationService {
  FirebaseNotificationService._();
  static final FirebaseNotificationService instance =
      FirebaseNotificationService._();
  // ✅ جديد: تتبع المحادثة المفتوحة حالياً
  String? currentOpenConversationId;
  String? authToken;
  final ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  Function(NotificationModel)? onMessage;
  Function(NotificationModel)? onClick;

  static const _channelId = 'schooly_notifications';
  static const _channelName = 'Schooly Notifications';

  Future<void> init({
    Function(NotificationModel)? onForegroundMessage,
    Function(NotificationModel)? onNotificationClick,
  }) async {
    if (_initialized) {
      onMessage = onForegroundMessage;
      onClick = onNotificationClick;
      return;
    }

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _local.initialize(
      settings: const InitializationSettings(android: android),
    );

    final androidPlugin = _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: 'Notifications for Schooly App',
        importance: Importance.high,
      ),
    );

    onMessage = onForegroundMessage;
    onClick = onNotificationClick;

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) async {
      final n = NotificationModel.fromRemoteMessage(msg);
      final incomingConvId = msg.data['conversation_id']?.toString();

      debugPrint('FCM DATA: ${msg.data}');
      debugPrint(
        'incomingConvId=$incomingConvId | currentOpen=$currentOpenConversationId',
      );

      if (incomingConvId != null &&
          incomingConvId == currentOpenConversationId) {
        return;
      }

      await refreshUnreadCount();
      onMessage?.call(n);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      final n = NotificationModel.fromRemoteMessage(msg);
      onClick?.call(n);
    });

    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<String?> getToken() => _messaging.getToken();

  void setAuthToken(String? token) {
    authToken = token;
    if (token == null || token.isEmpty) {
      unreadCountNotifier.value = 0;
    }
  }

  Future<void> refreshUnreadCount() async {
    if (authToken == null || authToken!.isEmpty) {
      unreadCountNotifier.value = 0;
      return;
    }

    try {
      final repo = NotificationRepository(NotificationRemoteDataSource(Dio()));
      final count = await repo.getUnreadCount(authToken!);
      unreadCountNotifier.value = count;
    } catch (_) {
      unreadCountNotifier.value = 0;
    }
  }

  void onTokenRefresh(void Function(String) cb) {
    _messaging.onTokenRefresh.listen(cb);
  }

  Future<NotificationModel?> getInitialNotification() async {
    final msg = await _messaging.getInitialMessage();
    if (msg == null) return null;
    return NotificationModel.fromRemoteMessage(msg);
  }

  Future<void> _showLocal(NotificationModel n) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Notifications for Schooly App',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );

    await _local.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: n.title,
      body: n.body,
      notificationDetails: details,
    );
  }
}
