import 'package:equatable/equatable.dart';

class Teacher extends Equatable {
  final int? id;
  final int? subjectId;
  final int? employeeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Teacher({
    this.id,
    this.subjectId,
    this.employeeId,
    this.createdAt,
    this.updatedAt,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json['id'] as int?,
    subjectId: json['subject_id'] as int?,
    employeeId: json['employee_id'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject_id': subjectId,
    'employee_id': employeeId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props {
    return [id, subjectId, employeeId, createdAt, updatedAt];
  }
}
