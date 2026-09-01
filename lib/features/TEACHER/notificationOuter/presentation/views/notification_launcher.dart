import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/TEACHER/notificationOuter/data/datasoucre/notification_remote_data_source.dart';
import 'package:schooly/features/TEACHER/notificationOuter/data/repositories/notification_repository.dart';
import 'package:schooly/features/TEACHER/notificationOuter/presentation/view_models/notification_cubit.dart';
import 'package:schooly/features/TEACHER/notificationOuter/presentation/views/notification_page.dart';
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';

void openNotificationPage(BuildContext context) {
  final userCubit = context.read<UserCubitt>();
  final repo = NotificationRepository(NotificationRemoteDataSource(Dio()));

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) =>
            NotificationCubit(repository: repo, userCubit: userCubit),
        child: const NotificationPage(),
      ),
    ),
  );
}
