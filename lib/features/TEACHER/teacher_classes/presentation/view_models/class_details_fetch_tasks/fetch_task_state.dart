part of 'fetch_task_cubit.dart';

@immutable
abstract class FetchTaskState {}

class FetchTaskInitial extends FetchTaskState {}

class FetchTaskLoading extends FetchTaskState {}

class FetchTaskSucces extends FetchTaskState {
  final List<FetchHomeworkAndTaskModel> fetchTask;

  FetchTaskSucces({required this.fetchTask});
}

class FetchTaskFailure extends FetchTaskState {
  final String errMassage;

  FetchTaskFailure(this.errMassage);
}
