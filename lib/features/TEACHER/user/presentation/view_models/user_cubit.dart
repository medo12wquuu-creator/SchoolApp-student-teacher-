import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/services/chat_socket_service.dart';
import 'package:schooly/core/services/firebaseteacher.dart';
import 'package:schooly/features/TEACHER/user/data/models/user_model.dart';
import 'package:schooly/features/TEACHER/user/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_state.dart';

class UserCubitt extends Cubit<UserState> {
  final UserRepository repo;

  UserCubitt(this.repo) : super(UserInitial());

  UserModel? currentUser;
  String? token;

  Future<void> saveSession({
    required String token,
    required UserModel user,
    required int roleId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    this.token = token;
    currentUser = user;

    // ضبط التوكن على ApiService ليُرسل مع كل طلب
    getIt<ApiService>().setToken(token);
    FirebaseNotificationService.instance.setAuthToken(token);
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(user.toJson()));
    await prefs.setString('role', user.role);
    await prefs.setInt('role_id', roleId);

    emit(UserLoaded(user));
  }

  Future<void> loadUser() async {
    emit(UserLoading());

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    final userJson = prefs.getString('user');

    if (token == null || token!.isEmpty || userJson == null) {
      emit(UserLoggedOut());
      return;
    }
    // إذا لم يوجد توكن:
    if (token == null || token!.isEmpty) {
      FirebaseNotificationService.instance.setAuthToken(null); // أضف هذا
      emit(UserLoggedOut());
      return;
    }
    // بعد السطر 55:
    FirebaseNotificationService.instance.setAuthToken(token!);
    // ضبط التوكن عند إعادة فتح التطبيق
    getIt<ApiService>().setToken(token!);

    try {
      final user = UserModel.fromJson(jsonDecode(userJson));
      currentUser = user;
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError('Failed to load user'));
    }
  }

  Future<void> refreshUserFromServer() async {
    if (token == null || token!.isEmpty) {
      emit(UserLoggedOut());
      return;
    }

    final result = await repo.getUser(token!);
    result.fold(
      (failure) {
        if (!isClosed) emit(UserError(failure.errMassage));
      },
      (user) async {
        currentUser = user;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(user.toJson()));
        await prefs.setString('role', user.role);

        if (!isClosed) emit(UserLoaded(user));
      },
    );
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    if (token == null || token!.isEmpty) {
      emit(UserLoggedOut());
      return;
    }

    emit(UserUpdating());

    final result = await repo.updateUser(token!, data);
    result.fold(
      (failure) {
        if (!isClosed) emit(UserError(failure.errMassage));
      },
      (updatedUser) async {
        currentUser = updatedUser;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(updatedUser.toJson()));

        if (!isClosed) emit(UserUpdated(updatedUser));
      },
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    currentUser = null;
    token = null;

    // 🔌 قطع اتصال الـ Socket نهائياً عند الخروج
    getIt<ChatSocketService>().disconnect();

    // حذف التوكن من ApiService
    getIt<ApiService>().clearToken();
    FirebaseNotificationService.instance.setAuthToken(null);
    emit(UserLoggedOut());
  }
}
