part of 'delete_report_cubit.dart';

@immutable
abstract class DeleteReportState {}

final class DeleteReportInitial extends DeleteReportState {}

final class DeleteReportLoading extends DeleteReportState {}

final class DeleteReportSuccess extends DeleteReportState {
  final String message;
  DeleteReportSuccess([this.message = 'تم حذف التقرير بنجاح']);
}

final class DeleteReportFailure extends DeleteReportState {
  final String errMassage;
  DeleteReportFailure(this.errMassage);
}
