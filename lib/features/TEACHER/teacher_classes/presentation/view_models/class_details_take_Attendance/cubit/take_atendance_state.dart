part of 'take_atendance_cubit.dart';

sealed class TakeAtendanceState {}

final class TakeAtendanceInitial extends TakeAtendanceState {}

final class TakeAtendanceLoading extends TakeAtendanceState {}

final class TakeAtendanceSuccess extends TakeAtendanceState {}

final class TakeAtendanceFailure extends TakeAtendanceState {
  final String errMassage;
  TakeAtendanceFailure(this.errMassage);
}
