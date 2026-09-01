part of 'modify_report_cubit.dart';

@immutable
abstract class ModifyReportState {}

final class ModifyReportInitial extends ModifyReportState {}

final class ModifyReportLoading extends ModifyReportState {}

final class ModifyReportSuccess extends ModifyReportState {
  final String message;
  ModifyReportSuccess([this.message = 'تم تعديل التقرير بنجاح']);
}

final class ModifyReportFailure extends ModifyReportState {
  final String errMassage;
  ModifyReportFailure(this.errMassage);
}
