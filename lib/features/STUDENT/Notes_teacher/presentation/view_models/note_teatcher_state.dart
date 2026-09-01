import 'package:schooly/features/STUDENT/Notes_teacher/data/model/model.dart';

abstract class NoteTeacherState {}

class NoteTeacherInitial extends NoteTeacherState {}

class NoteTeacherLoading extends NoteTeacherState {}

class NoteTeacherLoaded extends NoteTeacherState {
  final List<TeacherNoteModel> positiveNotes;
  final List<TeacherNoteModel> negativeNotes;
  final bool showPositive;

  NoteTeacherLoaded({
    required this.positiveNotes,
    required this.negativeNotes,
    this.showPositive = true,
  });

  List<TeacherNoteModel> get displayedNotes =>
      showPositive ? positiveNotes : negativeNotes;
}

class NoteTeacherError extends NoteTeacherState {
  final String message;

  NoteTeacherError(this.message);
}
