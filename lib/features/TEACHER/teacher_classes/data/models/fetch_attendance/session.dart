import 'package:equatable/equatable.dart';

import 'attendance.dart';

class Session extends Equatable {
  final int? id;
  final int? sectionId;
  final int? teacherId;
  final int? semesterId;
  final String? date;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Attendance>? attendances;

  const Session({
    this.id,
    this.sectionId,
    this.teacherId,
    this.semesterId,
    this.date,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.attendances,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    id: json['id'] as int?,
    sectionId: json['section_id'] as int?,
    teacherId: json['teacher_id'] as int?,
    semesterId: json['semester_id'] as int?,
    date: json['date'] as String?,
    status: json['status'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    attendances: (json['attendances'] as List<dynamic>?)
        ?.map((e) => Attendance.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'section_id': sectionId,
    'teacher_id': teacherId,
    'semester_id': semesterId,
    'date': date,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'attendances': attendances?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      sectionId,
      teacherId,
      semesterId,
      date,
      status,
      createdAt,
      updatedAt,
      attendances,
    ];
  }
}
