import 'package:equatable/equatable.dart';

import 'student.dart';
import 'teacher.dart';

class FetchStudentReports extends Equatable {
  final int? id;
  final int? teacherId;
  final int? studentId;
  final dynamic sectionId;
  final String? title;
  final String? description;
  final String? status;
  final int? academicYearId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Teacher? teacher;
  final Student? student;
  final dynamic section;
  final String? type;

  const FetchStudentReports({
    this.id,
    this.teacherId,
    this.studentId,
    this.sectionId,
    this.title,
    this.description,
    this.status,
    this.academicYearId,
    this.createdAt,
    this.updatedAt,
    this.teacher,
    this.student,
    this.section,
    this.type,
  });

  factory FetchStudentReports.fromJson(Map<String, dynamic> json) {
    return FetchStudentReports(
      id: json['id'] as int?,
      teacherId: json['teacher_id'] as int?,
      studentId: json['student_id'] as int?,
      sectionId: json['section_id'] as dynamic,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      academicYearId: json['academic_year_id'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      teacher: json['teacher'] == null
          ? null
          : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
      student: json['student'] == null
          ? null
          : Student.fromJson(json['student'] as Map<String, dynamic>),
      section: json['section'] as dynamic,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'teacher_id': teacherId,
    'student_id': studentId,
    'section_id': sectionId,
    'title': title,
    'description': description,
    'status': status,
    'academic_year_id': academicYearId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'teacher': teacher?.toJson(),
    'student': student?.toJson(),
    'section': section,
    'type': type,
  };

  @override
  List<Object?> get props {
    return [
      id,
      teacherId,
      studentId,
      sectionId,
      title,
      description,
      status,
      academicYearId,
      createdAt,
      updatedAt,
      teacher,
      student,
      section,
      type,
    ];
  }
}
