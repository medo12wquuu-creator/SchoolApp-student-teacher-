part of 'weak_schedual_cubit.dart';

sealed class WeakSchedualState {}

final class WeakSchedualInitial extends WeakSchedualState {}

final class WeakSchedualLoading extends WeakSchedualState {}

final class WeakSchedualSuccess extends WeakSchedualState {
  final List<Lesson> lessons;
  WeakSchedualSuccess({required this.lessons});
}

final class WeakSchedualFailure extends WeakSchedualState {
  final String errMassage;
  WeakSchedualFailure(this.errMassage);
}
