import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schooly/core/services/firebase_notification_service.dart';
import 'package:schooly/features/STUDENT/student_user/data/models/user_model.dart';
import 'package:schooly/features/STUDENT/student_user/data/repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repo;

  UserCubit(this.repo) : super(UserInitial());

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
      FirebaseNotificationService.instance.setAuthToken(null);
      emit(UserLoggedOut());
      return;
    }

    FirebaseNotificationService.instance.setAuthToken(token);

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

    try {
      final user = await repo.getUser(token!);
      currentUser = user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(user.toJson()));
      await prefs.setString('role', user.role);

      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError('Failed to refresh user'));
    }
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    emit(UserUpdating());

    try {
      final updatedUser = await repo.updateUser(token!, data);
      currentUser = updatedUser;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(updatedUser.toJson()));

      emit(UserUpdated(updatedUser));
    } catch (e) {
      emit(UserError('Failed to update user'));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    currentUser = null;
    token = null;
    FirebaseNotificationService.instance.setAuthToken(null);

    emit(UserLoggedOut());
  }
}
