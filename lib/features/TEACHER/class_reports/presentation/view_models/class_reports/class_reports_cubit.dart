import 'package:bloc/bloc.dart';
import 'package:schooly/features/TEACHER/class_reports/data/models/class_report_model.dart';
import 'package:schooly/features/TEACHER/class_reports/data/repo/class_reports_repo.dart';

part 'class_reports_state.dart';

class ClassReportsCubit extends Cubit<ClassReportsState> {
  final ClassReportsRepo classReportsRepo;
  ClassReportsCubit(this.classReportsRepo) : super(ClassReportsInitial());

  Future<void> fetchSectionReports({required String sectionId}) async {
    emit(ClassReportsLoading());
    try {
      var response = await classReportsRepo.fetchSectionReports(
        sectionId: sectionId,
      );
      response.fold(
        (failure) => emit(ClassReportsFailure(failure.errMassage)),
        (reports) => emit(ClassReportsSuccess(reports: reports)),
      );
    } catch (e) {
      emit(ClassReportsFailure(e.toString()));
    }
  }

  Future<void> modifyReport({
    required String reportId,
    String? title,
    String? description,
  }) async {
    emit(ClassReportModifyLoading());
    try {
      var response = await classReportsRepo.modifyReport(
        reportId: reportId,
        title: title,
        description: description,
      );
      response.fold(
        (failure) => emit(ClassReportModifyFailure(failure.errMassage)),
        (report) =>
            emit(ClassReportModifySuccess(report.title ?? 'تم تعديل التقرير')),
      );
    } catch (e) {
      emit(ClassReportModifyFailure(e.toString()));
    }
  }
}
