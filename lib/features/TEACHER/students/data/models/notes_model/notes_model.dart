import 'package:equatable/equatable.dart';

import 'subject.dart';
import 'teacher.dart';

class NotesModel extends Equatable {
  final int? id;
  final int? teacherId;
  final int? studentId;
  final int? subjectId;
  final int? semesterId;
  final String? type;
  final String? body;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Teacher? teacher;
  final Subject? subject;

  const NotesModel({
    this.id,
    this.teacherId,
    this.studentId,
    this.subjectId,
    this.semesterId,
    this.type,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.teacher,
    this.subject,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
    id: json['id'] as int?,
    teacherId: json['teacher_id'] as int?,
    studentId: json['student_id'] as int?,
    subjectId: json['subject_id'] as int?,
    semesterId: json['semester_id'] as int?,
    type: json['type'] as String?,
    body: json['body'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    teacher: json['teacher'] == null
        ? null
        : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
    subject: json['subject'] == null
        ? null
        : Subject.fromJson(json['subject'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'teacher_id': teacherId,
    'student_id': studentId,
    'subject_id': subjectId,
    'semester_id': semesterId,
    'type': type,
    'body': body,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'teacher': teacher?.toJson(),
    'subject': subject?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      teacherId,
      studentId,
      subjectId,
      semesterId,
      type,
      body,
      createdAt,
      updatedAt,
      teacher,
      subject,
    ];
  }
}
