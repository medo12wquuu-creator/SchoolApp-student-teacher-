part of 'send_homework_cubit.dart';

@immutable
abstract class SendHomeworkState {}

class SendHomeworkInitial extends SendHomeworkState {}

class SendHomeworkLoading extends SendHomeworkState {}

class SendHomeworkSuccess extends SendHomeworkState {
  final SendHomeworkAndTaskModel sendHomework;

  SendHomeworkSuccess({required this.sendHomework});
}

class SendHomeworkFailure extends SendHomeworkState {
  final String errMassage;

  SendHomeworkFailure(this.errMassage);
}
