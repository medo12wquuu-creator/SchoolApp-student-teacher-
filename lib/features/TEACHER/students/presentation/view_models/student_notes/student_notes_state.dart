part of 'student_notes_cubit.dart';

sealed class StudentNotesState {}

final class StudentNotesInitial extends StudentNotesState {}

final class StudentNotesLoading extends StudentNotesState {}

final class StudentNotesSuccess extends StudentNotesState {
  final List<NotesModel> notes;
  StudentNotesSuccess({required this.notes});
}

final class StudentNotesFailure extends StudentNotesState {
  final String errMassage;
  StudentNotesFailure(this.errMassage);
}
