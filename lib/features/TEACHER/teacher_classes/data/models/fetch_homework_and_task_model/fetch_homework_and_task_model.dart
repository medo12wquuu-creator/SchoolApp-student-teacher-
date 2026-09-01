import 'package:equatable/equatable.dart';

import 'subject.dart';
import 'teacher.dart';

class FetchHomeworkAndTaskModel extends Equatable {
  final int? id;
  final int? sectionId;
  final int? teacherId;
  final int? subjectId;
  final String? type;
  final String? description;
  final String? deliveryDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Teacher? teacher;
  final Subject? subject;

  const FetchHomeworkAndTaskModel({
    this.id,
    this.sectionId,
    this.teacherId,
    this.subjectId,
    this.type,
    this.description,
    this.deliveryDate,
    this.createdAt,
    this.updatedAt,
    this.teacher,
    this.subject,
  });

  factory FetchHomeworkAndTaskModel.fromJson(Map<String, dynamic> json) {
    return FetchHomeworkAndTaskModel(
      id: json['id'] as int?,
      sectionId: json['section_id'] as int?,
      teacherId: json['teacher_id'] as int?,
      subjectId: json['subject_id'] as int?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      deliveryDate: json['delivery_date'] as String?,
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
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'section_id': sectionId,
    'teacher_id': teacherId,
    'subject_id': subjectId,
    'type': type,
    'description': description,
    'delivery_date': deliveryDate,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'teacher': teacher?.toJson(),
    'subject': subject?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      sectionId,
      teacherId,
      subjectId,
      type,
      description,
      deliveryDate,
      createdAt,
      updatedAt,
      teacher,
      subject,
    ];
  }
}
