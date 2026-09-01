import 'package:equatable/equatable.dart';

import 'section.dart';
import 'subject.dart';
import 'time_slot.dart';

class TodaySchedualModel extends Equatable {
  final int? id;
  final int? semesterId;
  final int? sectionId;
  final int? teacherId;
  final int? subjectId;
  final int? timeSlotId;
  final int? dayOfWeek;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Subject? subject;
  final Section? section;
  final TimeSlot? timeSlot;

  const TodaySchedualModel({
    this.id,
    this.semesterId,
    this.sectionId,
    this.teacherId,
    this.subjectId,
    this.timeSlotId,
    this.dayOfWeek,
    this.createdAt,
    this.updatedAt,
    this.subject,
    this.section,
    this.timeSlot,
  });

  factory TodaySchedualModel.fromJson(Map<String, dynamic> json) {
    return TodaySchedualModel(
      id: json['id'] as int?,
      semesterId: json['semester_id'] as int?,
      sectionId: json['section_id'] as int?,
      teacherId: json['teacher_id'] as int?,
      subjectId: json['subject_id'] as int?,
      timeSlotId: json['time_slot_id'] as int?,
      dayOfWeek: json['day_of_weak'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      subject: json['subject'] == null
          ? null
          : Subject.fromJson(json['subject'] as Map<String, dynamic>),
      section: json['section'] == null
          ? null
          : Section.fromJson(json['section'] as Map<String, dynamic>),
      timeSlot: json['time_slot'] == null
          ? null
          : TimeSlot.fromJson(json['time_slot'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'semester_id': semesterId,
    'section_id': sectionId,
    'teacher_id': teacherId,
    'subject_id': subjectId,
    'time_slot_id': timeSlotId,
    'day_of_week': dayOfWeek,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'subject': subject?.toJson(),
    'section': section?.toJson(),
    'time_slot': timeSlot?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      semesterId,
      sectionId,
      teacherId,
      subjectId,
      timeSlotId,
      dayOfWeek,
      createdAt,
      updatedAt,
      subject,
      section,
      timeSlot,
    ];
  }
}
