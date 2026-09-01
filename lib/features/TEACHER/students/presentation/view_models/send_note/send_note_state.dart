part of 'send_note_cubit.dart';

sealed class SendNotesState {}

final class SendNotesInitial extends SendNotesState {}

final class SendNotesLoading extends SendNotesState {}

final class SendNotesSuccess extends SendNotesState {}

final class SendNotesFailure extends SendNotesState {
  final String errMassage;
  SendNotesFailure(this.errMassage);
}
