part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  // مررنا الموديل هون كرمال نقدر نصل للبيانات بالـ UI أو بالـ Listener
  final LoginModel loginModel;

  LoginSuccess(this.loginModel);
}

class LoginFailure extends LoginState {
  final String errMassage;

  LoginFailure(this.errMassage);
}
