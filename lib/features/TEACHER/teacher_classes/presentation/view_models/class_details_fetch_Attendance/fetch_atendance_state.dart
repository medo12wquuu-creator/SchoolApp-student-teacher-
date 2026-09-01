part of 'fetch_atendance_cubit.dart';

sealed class FetchAtendanceState {}

final class FetchAtendanceInitial extends FetchAtendanceState {}

final class FetchAtendanceLoading extends FetchAtendanceState {}

final class FetchAtendanceSuccess extends FetchAtendanceState {
  final FetchAttendanceModel data;
  final List<Student> studentsList;
  final Map<int, bool> attendanceStatus;

  FetchAtendanceSuccess({
    required this.data,
    required this.studentsList,
    required this.attendanceStatus,
  });
}

final class FetchAtendanceFailure extends FetchAtendanceState {
  final String errMassage;
  FetchAtendanceFailure(this.errMassage);
}

final class FetchAtendanceSaving extends FetchAtendanceState {}

final class FetchAtendanceSaveSuccess extends FetchAtendanceState {}

final class FetchAtendanceSaveFailure extends FetchAtendanceState {
  final String errMassage;
  FetchAtendanceSaveFailure(this.errMassage);
}