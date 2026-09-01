import 'package:equatable/equatable.dart';

import 'student.dart';

class Attendance extends Equatable {
  final int? id;
  final int? attendanceSessionId;
  final int? studentId;
  final int? semesterId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Student? student;

  const Attendance({
    this.id,
    this.attendanceSessionId,
    this.studentId,
    this.semesterId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.student,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json['id'] as int?,
    attendanceSessionId: json['attendance_session_id'] as int?,
    studentId: json['student_id'] as int?,
    semesterId: json['semester_id'] as int?,
    status: json['status'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    student: json['student'] == null
        ? null
        : Student.fromJson(json['student'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'attendance_session_id': attendanceSessionId,
    'student_id': studentId,
    'semester_id': semesterId,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'student': student?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      attendanceSessionId,
      studentId,
      semesterId,
      status,
      createdAt,
      updatedAt,
      student,
    ];
  }
}
