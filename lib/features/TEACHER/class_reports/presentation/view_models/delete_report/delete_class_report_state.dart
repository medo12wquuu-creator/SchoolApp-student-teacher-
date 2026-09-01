part of 'delete_class_report_cubit.dart';

@immutable
abstract class DeleteClassReportState {}

final class DeleteClassReportInitial extends DeleteClassReportState {}

final class DeleteClassReportLoading extends DeleteClassReportState {}

final class DeleteClassReportSuccess extends DeleteClassReportState {
  final String message;
  DeleteClassReportSuccess([this.message = 'تم حذف التقرير بنجاح']);
}

final class DeleteClassReportFailure extends DeleteClassReportState {
  final String errMassage;
  DeleteClassReportFailure(this.errMassage);
}
