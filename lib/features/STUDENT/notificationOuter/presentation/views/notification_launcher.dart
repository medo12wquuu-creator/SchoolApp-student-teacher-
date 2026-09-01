import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/notificationOuter/data/datasoucre/notification_remote_data_source.dart';
import 'package:schooly/features/STUDENT/notificationOuter/data/repositories/notification_repository.dart';
import 'package:schooly/features/STUDENT/notificationOuter/presentation/view_models/notification_cubit.dart';
import 'package:schooly/features/STUDENT/notificationOuter/presentation/views/notification_page.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';

void openNotificationPage(BuildContext context) {
  final userCubit = context.read<UserCubit>();
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
