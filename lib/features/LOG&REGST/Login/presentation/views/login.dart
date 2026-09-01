import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/views/widgets/login_body.dart';
import 'package:schooly/core/services/firebase_notification_service.dart';
import 'package:schooly/features/STUDENT/notificationOuter/data/datasoucre/notification_remote_data_source.dart';
import 'package:schooly/features/STUDENT/notificationOuter/data/repositories/notification_repository.dart';
import 'package:schooly/features/STUDENT/student_user/data/models/user_model.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import 'package:schooly/features/TEACHER/user/data/models/user_model.dart'
    as teacher_models;
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          final loginUser = state.loginModel.user;
          final roleId = loginUser?.roleId;

          // 1) قارن الـ role أولاً
          if (roleId == null || (roleId != 2 && roleId != 3)) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Unsupported role')));
            return; // لا تخزّن أي شيء
          }

          // 2) بعد التأكد من الـ role، تحقق من وجود التوكن
          final token = state.loginModel.token;
          if (token == null || token.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No token returned from server')),
            );
            return;
          }

          // 3) خزّن الجلسة في Cubit المطابق للدور
          if (roleId == 2) {
            final userCubit = context.read<UserCubit>();
            final student = UserModel(
              id: loginUser?.id ?? 0,
              first_name: loginUser?.email?.split('@').first ?? 'Student',
              email: loginUser?.email ?? '',
              phone: loginUser?.phoneNumber,
              role: 'student',
            );
            await userCubit.saveSession(
              token: token,
              user: student,
              roleId: roleId,
            );
            unawaited(userCubit.refreshUserFromServer());
          } else {
            final teacherCubit = context.read<UserCubitt>();
            final teacher = teacher_models.UserModel(
              id: loginUser?.id ?? 0,
              firstName: loginUser?.email?.split('@').first ?? 'Teacher',
              email: loginUser?.email ?? '',
              phone: loginUser?.phoneNumber,
              role: 'teacher',
            );
            await teacherCubit.saveSession(
              token: token,
              user: teacher,
              roleId: roleId,
            );
            unawaited(teacherCubit.refreshUserFromServer());
          }

          // أرسل FCM token في الخلفية حتى لا يؤخر الانتقال إلى الصفحة الرئيسية.
          unawaited(_syncFcmToken(token));

          if (!context.mounted) return;

          if (state.loginModel.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.loginModel.message!),
                backgroundColor: Colors.green,
              ),
            );
          }

          // 4) انتقل حسب الـ role (بعد نجاح التخزين)
          if (roleId == 2) {
            // طالب → صفحة الرئيسية بدون إمكانية الرجوع إلى شاشة تسجيل الدخول أو التسجيل
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          } else if (roleId == 3) {
            // // بحاجة لإكمال التسجيل
            // final registerCubit = RegisterCubit(
            //   RegisterRepository(RegisterRemoteDataSource(Dio())),
            // );
            // if (!context.mounted) return;
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => Register2Page(registerCubit: registerCubit),
            //   ),
            // );
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/teacher_home',
              (route) => false,
            );
          }

          // أي قيمة أخرى → لا تنقل، يبقى في صفحة Login
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMassage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return const Scaffold(body: LoginBody());
      },
    );
  }

  Future<void> _syncFcmToken(String token) async {
    try {
      final service = FirebaseNotificationService.instance;
      final granted = await service.requestPermission();
      if (!granted) return;

      final fcmToken = await service.getToken();
      if (fcmToken == null || fcmToken.isEmpty) return;

      await NotificationRepository(
        NotificationRemoteDataSource(Dio()),
      ).sendTokenToServer(fcmToken, token);
    } catch (_) {}
  }
}
