import 'package:bloc/bloc.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_details_repo.dart';

part 'send_report_state.dart';

class SendReportCubit extends Cubit<SendReportState> {
  final StudentDetailsRepo studentDetailsRepo;
  SendReportCubit(this.studentDetailsRepo) : super(SendReportInitial());

  Future<void> sendReport({
    required String studentId,
    required String title,
    required String description,
    required String type,
  }) async {
    emit(SendReportLoading());
    try {
      var response = await studentDetailsRepo.sendStudentReport(
        studentId: studentId,
        title: title,
        description: description,
        type: type,
      );
      response.fold(
        (failure) => emit(SendReportFailure(failure.errMassage)),
        (_) => emit(SendReportSuccess()),
      );
    } catch (e) {
      emit(SendReportFailure(e.toString()));
    }
  }
}
