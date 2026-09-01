import 'package:bloc/bloc.dart';
import 'package:schooly/features/TEACHER/students/data/models/notes_model/notes_model.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_details_repo.dart';

part 'student_notes_state.dart';

class StudentNotesCubit extends Cubit<StudentNotesState> {
  final StudentDetailsRepo studentDetailsRepo;
  StudentNotesCubit(this.studentDetailsRepo) : super(StudentNotesInitial());

  Future<void> fetchNotes({required String studentId}) async {
    emit(StudentNotesLoading());
    try {
      var response = await studentDetailsRepo.fetchStudentNotes(
        studentId: studentId,
      );
      response.fold(
        (failure) => emit(StudentNotesFailure(failure.errMassage)),
        (notes) => emit(StudentNotesSuccess(notes: notes)),
      );
    } catch (e) {
      emit(StudentNotesFailure(e.toString()));
    }
  }
}
