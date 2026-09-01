part of 'today_schedual_cubit.dart';

@immutable
abstract class TodaySchedualState {}

class TodaySchedualInitial extends TodaySchedualState {}

class TodaySchedualLoading extends TodaySchedualState {}

class TodaySchedualSuccess extends TodaySchedualState {
  final List<TodaySchedualModel> todaySchedual;

  TodaySchedualSuccess({required this.todaySchedual});
}

class TodaySchedualFailure extends TodaySchedualState {
  final String errMassage;

  TodaySchedualFailure(this.errMassage);
}
