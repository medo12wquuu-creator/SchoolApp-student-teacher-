import 'package:equatable/equatable.dart';

import 'session.dart';
import 'student.dart';

class FetchAttendanceModel extends Equatable {
  final Session? session;
  final List<Student>? students;
  final String? message;

  const FetchAttendanceModel({this.session, this.students, this.message});

  factory FetchAttendanceModel.fromJson(Map<String, dynamic> json) {
    return FetchAttendanceModel(
      session: json['session'] == null
          ? null
          : Session.fromJson(json['session'] as Map<String, dynamic>),
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => Student.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'session': session?.toJson(),
    'students': students?.map((e) => e.toJson()).toList(),
    'message': message,
  };

  @override
  List<Object?> get props => [session, students, message];
}
