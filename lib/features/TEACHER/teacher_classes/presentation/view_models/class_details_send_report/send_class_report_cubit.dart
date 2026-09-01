import 'package:bloc/bloc.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';

part 'send_class_report_state.dart';

class SendClassReportCubit extends Cubit<SendClassReportState> {
  final ClassDetailsRepo classDetailsRepo;
  SendClassReportCubit(this.classDetailsRepo) : super(SendClassReportInitial());

  Future<void> sendClassReport({
    required String sectionId,
    required String title,
    required String description,
    required String type,
  }) async {
    emit(SendClassReportLoading());
    try {
      var response = await classDetailsRepo.sendClassReport(
        sectionId: sectionId,
        title: title,
        description: description,
      );
      response.fold(
        (failure) => emit(SendClassReportFailure(failure.errMassage)),
        (model) => emit(SendClassReportSuccess(model.message)),
      );
    } catch (e) {
      emit(SendClassReportFailure(e.toString()));
    }
  }
}
