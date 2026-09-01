part of 'marks_cubit.dart';

@immutable
abstract class MarksState {}

final class MarksInitial extends MarksState {}

final class MarksLoading extends MarksState {}

final class MarksSuccess extends MarksState {}

final class MarksFailure extends MarksState {
  final String errMassage;
  MarksFailure(this.errMassage);
}
