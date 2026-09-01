import 'package:equatable/equatable.dart';

import 'question.dart';
import 'section.dart';

class Data extends Equatable {
  final int? teacherId;
  final int? subjectId;
  final int? semesterId;
  final String? title;
  final String? description;
  final int? durationMinutes;
  final String? startsAt;
  final String? endsAt;
  final String? status;
  final String? updatedAt;
  final String? createdAt;
  final int? id;
  final List<Question>? questions;
  final List<Section>? sections;

  const Data({
    this.teacherId,
    this.subjectId,
    this.semesterId,
    this.title,
    this.description,
    this.durationMinutes,
    this.startsAt,
    this.endsAt,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.questions,
    this.sections,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    teacherId: json['teacher_id'] as int?,
    subjectId: json['subject_id'] as int?,
    semesterId: json['semester_id'] as int?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    durationMinutes: json['duration_minutes'] as int?,
    startsAt: json['starts_at'] as String?,
    endsAt: json['ends_at'] as String?,
    status: json['status'] as String?,
    updatedAt: json['updated_at'] as String?,
    createdAt: json['created_at'] as String?,
    id: json['id'] as int?,
    questions: (json['questions'] as List<dynamic>?)
        ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList(),
    sections: (json['sections'] as List<dynamic>?)
        ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'teacher_id': teacherId,
    'subject_id': subjectId,
    'semester_id': semesterId,
    'title': title,
    'description': description,
    'duration_minutes': durationMinutes,
    'starts_at': startsAt,
    'ends_at': endsAt,
    'status': status,
    'updated_at': updatedAt,
    'created_at': createdAt,
    'id': id,
    'questions': questions?.map((e) => e.toJson()).toList(),
    'sections': sections?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props {
    return [
      teacherId,
      subjectId,
      semesterId,
      title,
      description,
      durationMinutes,
      startsAt,
      endsAt,
      status,
      updatedAt,
      createdAt,
      id,
      questions,
      sections,
    ];
  }
}
