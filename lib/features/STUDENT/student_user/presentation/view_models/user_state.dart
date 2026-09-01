import 'package:schooly/features/STUDENT/student_user/data/models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

class UserUpdating extends UserState {}

class UserUpdated extends UserState {
  final UserModel user;
  UserUpdated(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserLoggedOut extends UserState {}
