import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_details_repo.dart';

part 'delete_report_state.dart';

class DeleteReportCubit extends Cubit<DeleteReportState> {
  final StudentDetailsRepo studentDetailsRepo;
  DeleteReportCubit(this.studentDetailsRepo) : super(DeleteReportInitial());

  Future<void> deleteReport({required String reportId}) async {
    emit(DeleteReportLoading());
    try {
      var response = await studentDetailsRepo.deleteStudentReport(
        reportId: reportId,
      );
      response.fold(
        (failure) => emit(DeleteReportFailure(failure.errMassage)),
        (_) => emit(DeleteReportSuccess()),
      );
    } catch (e) {
      emit(DeleteReportFailure(e.toString()));
    }
  }
}
