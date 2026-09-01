part of 'delete_task_homework_cubit.dart';

@immutable
abstract class DeleteTaskHomeworkState {}

final class DeleteTaskHomeworkInitial extends DeleteTaskHomeworkState {}

final class DeleteTaskHomeworkLoading extends DeleteTaskHomeworkState {}

final class DeleteTaskHomeworkSuccess extends DeleteTaskHomeworkState {}

final class DeleteTaskHomeworkFailure extends DeleteTaskHomeworkState {
  final String errMassage;
  DeleteTaskHomeworkFailure(this.errMassage);
}