import 'package:equatable/equatable.dart';

import 'exam.dart';
import 'section.dart';

class FetchQuizScoreModel extends Equatable {
  final String? message;
  final Exam? exam;
  final List<Section>? sections;

  const FetchQuizScoreModel({this.message, this.exam, this.sections});

  factory FetchQuizScoreModel.fromJson(Map<String, dynamic> json) {
    return FetchQuizScoreModel(
      message: json['message'] as String?,
      exam: json['exam'] == null
          ? null
          : Exam.fromJson(json['exam'] as Map<String, dynamic>),
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'exam': exam?.toJson(),
    'sections': sections?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [message, exam, sections];
}
