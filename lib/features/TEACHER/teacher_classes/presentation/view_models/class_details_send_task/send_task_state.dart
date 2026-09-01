part of 'send_task_cubit.dart';

@immutable
abstract class SendTaskState {}

class SendTaskInitial extends SendTaskState {}

class SendTaskLoading extends SendTaskState {}

class SendTaskSuccess extends SendTaskState {
  final SendHomeworkAndTaskModel sendTask;

  SendTaskSuccess({required this.sendTask});
}

class SendTaskFailure extends SendTaskState {
  final String errMassage;

  SendTaskFailure(this.errMassage);
}
