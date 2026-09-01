import 'package:equatable/equatable.dart';

import 'employee.dart';

class Teacher extends Equatable {
  final int? id;
  final int? subjectId;
  final int? employeeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Employee? employee;

  const Teacher({
    this.id,
    this.subjectId,
    this.employeeId,
    this.createdAt,
    this.updatedAt,
    this.employee,
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
    employee: json['employee'] == null
        ? null
        : Employee.fromJson(json['employee'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject_id': subjectId,
    'employee_id': employeeId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'employee': employee?.toJson(),
  };

  @override
  List<Object?> get props {
    return [id, subjectId, employeeId, createdAt, updatedAt, employee];
  }
}
