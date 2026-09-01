part of 'send_class_report_cubit.dart';

sealed class SendClassReportState {}

final class SendClassReportInitial extends SendClassReportState {}

final class SendClassReportLoading extends SendClassReportState {}

final class SendClassReportSuccess extends SendClassReportState {
  final String? message;
  SendClassReportSuccess(this.message);
}

final class SendClassReportFailure extends SendClassReportState {
  final String errMassage;
  SendClassReportFailure(this.errMassage);
}
