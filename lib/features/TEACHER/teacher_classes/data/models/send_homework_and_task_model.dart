import 'package:equatable/equatable.dart';

class SendHomeworkAndTaskModel extends Equatable {
  final String? sectionId;
  final String? teacherId;
  final String? type;
  final String? title;
  final String? description;
  final String? deliveryDate;
  final int? subjectId;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  const SendHomeworkAndTaskModel({
    this.sectionId,
    this.teacherId,
    this.type,
    this.title,
    this.description,
    this.deliveryDate,
    this.subjectId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory SendHomeworkAndTaskModel.fromJson(Map<String, dynamic> json) {
    return SendHomeworkAndTaskModel(
      sectionId: json['section_id']?.toString(),
      teacherId: json['teacher_id']?.toString(),
      type: json['type'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      deliveryDate: json['delivery_date'] as String?,
      subjectId: json['subject_id'] as int?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      id: json['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'section_id': sectionId,
    'teacher_id': teacherId,
    'type': type,
    'title': title,
    'description': description,
    'delivery_date': deliveryDate,
    'subject_id': subjectId,
    'updated_at': updatedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'id': id,
  };

  @override
  List<Object?> get props {
    return [
      sectionId,
      teacherId,
      type,
      title,
      description,
      deliveryDate,
      subjectId,
      updatedAt,
      createdAt,
      id,
    ];
  }
}
