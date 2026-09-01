import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/class_reports/data/repo/class_reports_repo.dart';

part 'delete_class_report_state.dart';

class DeleteClassReportCubit extends Cubit<DeleteClassReportState> {
  final ClassReportsRepo classReportsRepo;
  DeleteClassReportCubit(this.classReportsRepo)
    : super(DeleteClassReportInitial());

  Future<void> deleteReport({required String reportId}) async {
    emit(DeleteClassReportLoading());
    try {
      var response = await classReportsRepo.deleteReport(reportId: reportId);
      response.fold(
        (failure) => emit(DeleteClassReportFailure(failure.errMassage)),
        (_) => emit(DeleteClassReportSuccess()),
      );
    } catch (e) {
      emit(DeleteClassReportFailure(e.toString()));
    }
  }
}
