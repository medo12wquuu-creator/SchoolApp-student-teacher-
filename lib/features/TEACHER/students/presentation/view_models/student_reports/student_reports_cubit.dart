import 'package:bloc/bloc.dart';

import 'package:schooly/features/TEACHER/students/data/models/fetch_student_reports/fetch_student_reports.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_details_repo.dart';

part 'student_reports_state.dart';

class StudentReportsCubit extends Cubit<StudentReportsState> {
  final StudentDetailsRepo studentDetailsRepo;
  StudentReportsCubit(this.studentDetailsRepo) : super(StudentReportsInitial());

  Future<void> fetchReports({required String studentId}) async {
    emit(StudentReportsLoading());
    try {
      var response = await studentDetailsRepo.fetchStudentReports(
        studentId: studentId,
      );
      response.fold(
        (failure) => emit(StudentReportsFailure(failure.errMassage)),
        (reports) => emit(StudentReportsSuccess(reports: reports)),
      );
    } catch (e) {
      emit(StudentReportsFailure(e.toString()));
    }
  }
}
