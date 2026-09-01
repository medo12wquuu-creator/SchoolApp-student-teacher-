part of 'class_reports_cubit.dart';

sealed class ClassReportsState {}

final class ClassReportsInitial extends ClassReportsState {}

final class ClassReportsLoading extends ClassReportsState {}

final class ClassReportsSuccess extends ClassReportsState {
  final List<ClassReportModel> reports;
  ClassReportsSuccess({required this.reports});
}

final class ClassReportsFailure extends ClassReportsState {
  final String errMassage;
  ClassReportsFailure(this.errMassage);
}

final class ClassReportModifyLoading extends ClassReportsState {}

final class ClassReportModifySuccess extends ClassReportsState {
  final String message;
  ClassReportModifySuccess(this.message);
}

final class ClassReportModifyFailure extends ClassReportsState {
  final String errMassage;
  ClassReportModifyFailure(this.errMassage);
}
