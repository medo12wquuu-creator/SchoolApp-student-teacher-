part of 'fetch_students_cubit.dart';

@immutable
abstract class FetchStudentsState {}

final class FetchStudentsInitial extends FetchStudentsState {}

final class FetchStudentsLoading extends FetchStudentsState {}

final class FetchStudentsSuccess extends FetchStudentsState {
  final List<FetchStudentsModel> students;
  final List<FetchWeightsModel> weights;
  FetchStudentsSuccess({
    required this.students,
    this.weights = const [],
  });
}

final class FetchStudentsFailure extends FetchStudentsState {
  final String errMassage;
  FetchStudentsFailure(this.errMassage);
}
