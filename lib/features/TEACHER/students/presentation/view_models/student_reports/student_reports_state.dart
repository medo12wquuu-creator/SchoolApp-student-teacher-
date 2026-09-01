part of 'student_reports_cubit.dart';

sealed class StudentReportsState {}

final class StudentReportsInitial extends StudentReportsState {}

final class StudentReportsLoading extends StudentReportsState {}

final class StudentReportsSuccess extends StudentReportsState {
  final List<FetchStudentReports> reports;
  StudentReportsSuccess({required this.reports});
}

final class StudentReportsFailure extends StudentReportsState {
  final String errMassage;
  StudentReportsFailure(this.errMassage);
}
