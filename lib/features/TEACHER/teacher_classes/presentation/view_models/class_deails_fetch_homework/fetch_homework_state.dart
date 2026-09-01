part of 'fetch_homework_cubit.dart';

@immutable
abstract class FetchHomeworkState {}

class FetchHomeworkInitial extends FetchHomeworkState {}

class FetchHomeworkLoading extends FetchHomeworkState {}

class FetchHomeworkSucces extends FetchHomeworkState {
  final List<FetchHomeworkAndTaskModel> fetchHomework;

  FetchHomeworkSucces({required this.fetchHomework});
}

class FetchHomeworkFailure extends FetchHomeworkState {
  final String errMassage;

  FetchHomeworkFailure(this.errMassage);
}
