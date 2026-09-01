part of 'send_report_cubit.dart';

sealed class SendReportState {}

final class SendReportInitial extends SendReportState {}

final class SendReportLoading extends SendReportState {}

final class SendReportSuccess extends SendReportState {}

final class SendReportFailure extends SendReportState {
  final String errMassage;
  SendReportFailure(this.errMassage);
}
