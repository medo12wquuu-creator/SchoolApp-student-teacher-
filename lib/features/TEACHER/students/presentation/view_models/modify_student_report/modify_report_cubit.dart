import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_details_repo.dart';

part 'modify_report_state.dart';

class ModifyReportCubit extends Cubit<ModifyReportState> {
  final StudentDetailsRepo studentDetailsRepo;
  ModifyReportCubit(this.studentDetailsRepo) : super(ModifyReportInitial());

  Future<void> modifyReport({
    required String reportId,
    String? title,
    String? description,
  }) async {
    emit(ModifyReportLoading());
    try {
      var response = await studentDetailsRepo.modifyStudentReport(
        reportId: reportId,
        title: title,
        description: description,
      );
      response.fold(
        (failure) => emit(ModifyReportFailure(failure.errMassage)),
        (_) => emit(ModifyReportSuccess()),
      );
    } catch (e) {
      emit(ModifyReportFailure(e.toString()));
    }
  }
}
