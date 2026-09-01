import 'package:equatable/equatable.dart';

import 'lesson.dart';

class WeakSchedualModel extends Equatable {
  final String? message;
  final List<Lesson>? lessons;

  const WeakSchedualModel({this.message, this.lessons});

  factory WeakSchedualModel.fromJson(Map<String, dynamic> json) {
    return WeakSchedualModel(
      message: json['message'] as String?,
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'lessons': lessons?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [message, lessons];
}
