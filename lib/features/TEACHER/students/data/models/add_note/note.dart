import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String? teacherId;
  final String? studentId;
  final int? subjectId;
  final int? semesterId;
  final String? type;
  final String? body;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  const Note({
    this.teacherId,
    this.studentId,
    this.subjectId,
    this.semesterId,
    this.type,
    this.body,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    teacherId: json['teacher_id'] as String?,
    studentId: json['student_id'] as String?,
    subjectId: json['subject_id'] as int?,
    semesterId: json['semester_id'] as int?,
    type: json['type'] as String?,
    body: json['body'] as String?,
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    id: json['id'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'teacher_id': teacherId,
    'student_id': studentId,
    'subject_id': subjectId,
    'semester_id': semesterId,
    'type': type,
    'body': body,
    'updated_at': updatedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'id': id,
  };

  @override
  List<Object?> get props {
    return [
      teacherId,
      studentId,
      subjectId,
      semesterId,
      type,
      body,
      updatedAt,
      createdAt,
      id,
    ];
  }
}
