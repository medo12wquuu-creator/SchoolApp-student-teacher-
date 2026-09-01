import 'package:equatable/equatable.dart';

import 'teacher.dart';

class FetchTeacherProfileModel extends Equatable {
  final String? message;
  final Teacher? teacher;

  const FetchTeacherProfileModel({this.message, this.teacher});

  factory FetchTeacherProfileModel.fromJson(Map<String, dynamic> json) {
    return FetchTeacherProfileModel(
      message: json['message'] as String?,
      teacher: json['teacher'] == null
          ? null
          : Teacher.fromJson(json['teacher'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'teacher': teacher?.toJson(),
  };

  @override
  List<Object?> get props => [message, teacher];
}
