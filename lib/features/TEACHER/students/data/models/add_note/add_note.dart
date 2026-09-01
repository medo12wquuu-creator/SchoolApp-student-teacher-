import 'package:equatable/equatable.dart';

import 'note.dart';

class AddNote extends Equatable {
  final String? message;
  final Note? note;

  const AddNote({this.message, this.note});

  factory AddNote.fromJson(Map<String, dynamic> json) => AddNote(
    message: json['message'] as String?,
    note: json['note'] == null
        ? null
        : Note.fromJson(json['note'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {'message': message, 'note': note?.toJson()};

  @override
  List<Object?> get props => [message, note];
}
