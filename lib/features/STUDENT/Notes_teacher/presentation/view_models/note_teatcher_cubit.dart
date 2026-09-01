import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/data/model/model.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/data/repository/note_teatcher_repository.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import 'note_teatcher_state.dart';

class NoteTeacherCubit extends Cubit<NoteTeacherState> {
  final NoteTeacherRepository repository;
  final UserCubit userCubit;

  List<TeacherNoteModel> _positive = [];
  List<TeacherNoteModel> _negative = [];
  bool _showPositive = true;

  NoteTeacherCubit(this.repository, this.userCubit)
    : super(NoteTeacherInitial());

  Future<void> loadNotes() async {
    if (!isClosed) emit(NoteTeacherLoading());
    print('========== NoteTeacherCubit.loadGrades ==========');
    try {
      final token = userCubit.token ?? '';
      print('🔑 Token: $token');
      final data = await repository.fetchNotes(token);
      print(
        '📦 Positive: ${data['positive']?.length} | Negative: ${data['negative']?.length}',
      );
      _positive = List<TeacherNoteModel>.from(data['positive'] ?? []);
      _negative = List<TeacherNoteModel>.from(data['negative'] ?? []);
      _showPositive = true;
      _emitLoaded();
      if (!isClosed) {
        emit(
          NoteTeacherLoaded(
            positiveNotes: _positive,
            negativeNotes: _negative,
            showPositive: _showPositive,
          ),
        );
      }
    } catch (e) {
      print('NoteTeacherCubit error: $e');
      if (!isClosed) emit(NoteTeacherError(e.toString()));
    }
  }

  void showPositiveNotes() {
    _showPositive = true;
    _emitLoaded();
  }

  void showNegativeNotes() {
    _showPositive = false;
    _emitLoaded();
  }

  void _emitLoaded() {
    emit(
      NoteTeacherLoaded(
        positiveNotes: _positive,
        negativeNotes: _negative,
        showPositive: _showPositive,
      ),
    );
  }
}
