import 'package:bloc/bloc.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_details_repo.dart';

part 'send_note_state.dart';

class SendNotesCubit extends Cubit<SendNotesState> {
  final StudentDetailsRepo studentDetailsRepo;
  SendNotesCubit(this.studentDetailsRepo) : super(SendNotesInitial());

  Future<void> sendNote({
    required String studentId,
    required String subjectId,
    required String semesterId,
    required String type,
    required String body,
  }) async {
    emit(SendNotesLoading());
    try {
      var response = await studentDetailsRepo.sendStudentNote(
        studentId: studentId,
        subjectId: subjectId,
        semesterId: semesterId,
        type: type,
        body: body,
      );
      response.fold(
        (failure) => emit(SendNotesFailure(failure.errMassage)),
        (_) => emit(SendNotesSuccess()),
      );
    } catch (e) {
      emit(SendNotesFailure(e.toString()));
    }
  }
}
