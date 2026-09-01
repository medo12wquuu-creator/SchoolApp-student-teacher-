part of 'teacher_reports_cubit.dart';

@immutable
abstract class TeacherReportsState {
  const TeacherReportsState();
}

final class TeacherReportsInitial extends TeacherReportsState {
  const TeacherReportsInitial();
}

final class TeacherReportsLoading extends TeacherReportsState {
  const TeacherReportsLoading();
}

final class TeacherReportsSuccess extends TeacherReportsState {
  final TeacherReportsModel reports;

  const TeacherReportsSuccess(this.reports);
}

final class TeacherReportsFailure extends TeacherReportsState {
  final String message;
  final String? debugDetails;

  const TeacherReportsFailure(this.message, {this.debugDetails});
}