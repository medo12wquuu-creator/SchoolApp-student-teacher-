import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/services/firebaseteacher.dart';

import 'package:schooly/features/TEACHER/notificationOuter/data/model/notification_model.dart';
import 'package:schooly/features/TEACHER/notificationOuter/data/repositories/notification_repository.dart';
import 'package:schooly/features/TEACHER/notificationOuter/presentation/view_models/notification_state.dart';
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;
  final UserCubitt userCubit;

  NotificationCubit({required this.repository, required this.userCubit})
    : super(NotificationState());

  final List<NotificationModel> _notifications = [];
  bool _listenersRegistered = false;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final service = FirebaseNotificationService.instance;

    service.onMessage = (_) {
      refresh();
    };

    service.onClick = (_) {
      refresh();
    };

    final fcmToken = await service.getToken();
    debugPrint('FCM TOKEN = $fcmToken');

    if (fcmToken != null && userCubit.token != null) {
      try {
        await repository.sendTokenToServer(fcmToken, userCubit.token!);
      } catch (_) {}
    }

    if (!_listenersRegistered) {
      _listenersRegistered = true;
      service.onTokenRefresh((newToken) async {
        if (userCubit.token != null) {
          try {
            await repository.sendTokenToServer(newToken, userCubit.token!);
          } catch (_) {}
        }
      });
    }

    final initial = await service.getInitialNotification();
    if (initial != null) {
      _notifications.insert(0, initial);
    }

    await refresh();
  }

  Future<void> refresh() async {
    if (isClosed) return;

    if (userCubit.token == null || userCubit.token!.isEmpty) {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
      return;
    }

    try {
      final notifications = await repository.getNotifications(userCubit.token!);
      final unreadCount = await repository.getUnreadCount(userCubit.token!);

      _notifications
        ..clear()
        ..addAll(notifications);

      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: null,
            notifications: List<NotificationModel>.from(_notifications),
            unreadCount: unreadCount,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
            notifications: List<NotificationModel>.from(_notifications),
          ),
        );
      }
    }
  }

  Future<void> markAllRead() async {
    if (isClosed) return;
    if (userCubit.token == null || userCubit.token!.isEmpty) return;

    try {
      await repository.markAllRead(userCubit.token!);
      FirebaseNotificationService.instance.unreadCountNotifier.value = 0;
      await refresh();
    } catch (_) {}
  }

  Future<void> deleteNotification(String notificationId) async {
    if (isClosed) return;
    if (userCubit.token == null || userCubit.token!.isEmpty) return;

    try {
      await repository.deleteNotification(notificationId, userCubit.token!);
      _notifications.removeWhere((item) => item.id == notificationId);
      if (!isClosed) {
        emit(
          state.copyWith(
            notifications: List<NotificationModel>.from(_notifications),
            unreadCount: state.unreadCount,
          ),
        );
      }
      await refresh();
    } catch (_) {}
  }

  @override
  Future<void> close() {
    FirebaseNotificationService.instance.onMessage = null;
    FirebaseNotificationService.instance.onClick = null;
    return super.close();
  }
}
