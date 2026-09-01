part of 'send_teacher_profile_info_cubit.dart';

sealed class SendTeacherProfileInfoState {}

final class SendTeacherProfileInfoInitial extends SendTeacherProfileInfoState {}

final class SendTeacherProfileInfoLoading extends SendTeacherProfileInfoState {}

final class SendTeacherProfileInfoSuccess extends SendTeacherProfileInfoState {
  final String? message;
  SendTeacherProfileInfoSuccess(this.message);
}

final class SendTeacherProfileInfoFailure extends SendTeacherProfileInfoState {
  final String errMassage;
  SendTeacherProfileInfoFailure(this.errMassage);
}
