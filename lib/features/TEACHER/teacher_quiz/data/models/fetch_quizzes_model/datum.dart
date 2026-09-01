import 'package:equatable/equatable.dart';

import 'attempts.dart';
import 'section.dart';

class Datum extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final String? status;
  final bool? isLive;
  final String? startsAt;
  final String? endsAt;
  final int? durationMinutes;
  final int? totalMarks;
  final int? questionsCount;
  final Attempts? attempts;
  final List<Section>? sections;
  final List<Map<String, dynamic>>? questions;

  const Datum({
    this.id,
    this.title,
    this.description,
    this.status,
    this.isLive,
    this.startsAt,
    this.endsAt,
    this.durationMinutes,
    this.totalMarks,
    this.questionsCount,
    this.attempts,
    this.sections,
    this.questions,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json['id'] as int?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    status: json['status'] as String?,
    isLive: json['is_live'] as bool?,
    startsAt: json['starts_at'] as String?,
    endsAt: json['ends_at'] as String?,
    durationMinutes: json['duration_minutes'] as int?,
    totalMarks: json['total_marks'] as int?,
    questionsCount: json['questions_count'] as int?,
    attempts: json['attempts'] == null
        ? null
        : Attempts.fromJson(json['attempts'] as Map<String, dynamic>),
    sections: (json['sections'] as List<dynamic>?)
        ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
        .toList(),
    questions: (json['questions'] as List<dynamic>?)
        ?.map((e) => Map<String, dynamic>.from(e as Map))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'is_live': isLive,
    'starts_at': startsAt,
    'ends_at': endsAt,
    'duration_minutes': durationMinutes,
    'total_marks': totalMarks,
    'questions_count': questionsCount,
    'attempts': attempts?.toJson(),
    'sections': sections?.map((e) => e.toJson()).toList(),
    'questions': questions,
  };

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description,
      status,
      isLive,
      startsAt,
      endsAt,
      durationMinutes,
      totalMarks,
      questionsCount,
      attempts,
      sections,
      questions,
    ];
  }
}
