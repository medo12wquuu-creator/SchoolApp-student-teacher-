import 'package:equatable/equatable.dart';

import 'option.dart';

class Question extends Equatable {
  final int? id;
  final int? examId;
  final String? body;
  final String? marks;
  final int? order;
  final String? createdAt;
  final String? updatedAt;
  final List<Option>? options;

  const Question({
    this.id,
    this.examId,
    this.body,
    this.marks,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'] as int?,
    examId: json['exam_id'] as int?,
    body: json['body'] as String?,
    marks: json['marks']?.toString(),
    order: json['order'] as int?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    options: (json['options'] as List<dynamic>?)
        ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'exam_id': examId,
    'body': body,
    'marks': marks,
    'order': order,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'options': options?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props {
    return [id, examId, body, marks, order, createdAt, updatedAt, options];
  }
}
