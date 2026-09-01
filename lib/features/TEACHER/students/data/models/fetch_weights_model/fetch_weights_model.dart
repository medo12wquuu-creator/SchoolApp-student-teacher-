import 'package:equatable/equatable.dart';

import 'grade_type.dart';

class FetchWeightsModel extends Equatable {
  final int? id;
  final int? subjectId;
  final int? classroomId;
  final int? semesterId;
  final int? stageId;
  final int? gradeTypeId;
  final String? maxScore;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final GradeType? gradeType;

  const FetchWeightsModel({
    this.id,
    this.subjectId,
    this.classroomId,
    this.semesterId,
    this.stageId,
    this.gradeTypeId,
    this.maxScore,
    this.createdAt,
    this.updatedAt,
    this.gradeType,
  });

  factory FetchWeightsModel.fromJson(Map<String, dynamic> json) {
    return FetchWeightsModel(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : int.tryParse(json['id']?.toString() ?? ''),
      subjectId: json['subject_id'] is num
          ? (json['subject_id'] as num).toInt()
          : int.tryParse(json['subject_id']?.toString() ?? ''),
      classroomId: json['classroom_id'] is num
          ? (json['classroom_id'] as num).toInt()
          : int.tryParse(json['classroom_id']?.toString() ?? ''),
      semesterId: json['semester_id'] is num
          ? (json['semester_id'] as num).toInt()
          : int.tryParse(json['semester_id']?.toString() ?? ''),
      stageId: json['stage_id'] is num
          ? (json['stage_id'] as num).toInt()
          : int.tryParse(json['stage_id']?.toString() ?? ''),
      gradeTypeId: json['grade_type_id'] is num
          ? (json['grade_type_id'] as num).toInt()
          : int.tryParse(json['grade_type_id']?.toString() ?? ''),
      maxScore: json['max_score']
          ?.toString(), // 🟢 تحويل آمن إلى String مهما كان نوعه من السيرفر (int أو double أو String)
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      gradeType: json['grade_type'] == null
          ? null
          : GradeType.fromJson(json['grade_type'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject_id': subjectId,
    'classroom_id': classroomId,
    'semester_id': semesterId,
    'stage_id': stageId,
    'grade_type_id': gradeTypeId,
    'max_score': maxScore,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'grade_type': gradeType?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      subjectId,
      classroomId,
      semesterId,
      stageId,
      gradeTypeId,
      maxScore,
      createdAt,
      updatedAt,
      gradeType,
    ];
  }
}
