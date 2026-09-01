import 'package:equatable/equatable.dart';

class Option extends Equatable {
  final int? id;
  final int? examQuestionId;
  final String? body;
  final int? isCorrect;
  final int? order;
  final String? createdAt;
  final String? updatedAt;

  const Option({
    this.id,
    this.examQuestionId,
    this.body,
    this.isCorrect,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json['id'] as int?,
    examQuestionId: json['exam_question_id'] as int?,
    body: json['body'] as String?,
    isCorrect: _toInt(json['is_correct']),
    order: json['order'] as int?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
  );

  /// قراءة is_correct سواء كان 1/0 (int) أو true/false (bool)
  static int? _toInt(dynamic value) {
    if (value is bool) return value ? 1 : 0;
    if (value is num) return value.toInt();
    return null;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'exam_question_id': examQuestionId,
    'body': body,
    'is_correct': isCorrect,
    'order': order,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  @override
  List<Object?> get props {
    return [id, examQuestionId, body, isCorrect, order, createdAt, updatedAt];
  }
}
