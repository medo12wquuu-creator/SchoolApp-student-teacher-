part of 'send_new_password_cubit.dart';

sealed class SendNewPasswordState {}

final class SendNewPasswordInitial extends SendNewPasswordState {}

final class SendNewPasswordLoading extends SendNewPasswordState {}

final class SendNewPasswordSuccess extends SendNewPasswordState {
  final String? message;
  SendNewPasswordSuccess(this.message);
}

final class SendNewPasswordFailure extends SendNewPasswordState {
  final String errMassage;
  SendNewPasswordFailure(this.errMassage);
}
