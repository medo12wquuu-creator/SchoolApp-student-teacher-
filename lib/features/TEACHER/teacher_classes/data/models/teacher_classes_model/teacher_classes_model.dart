import 'package:equatable/equatable.dart';

import 'class_a.dart';
import 'class_b.dart';
import 'sections.dart';
import 'semester.dart';

class TeacherClassesModel extends Equatable {
  final String? message;
  final Sections? sections;
  final SemesterModel? semester;

  const TeacherClassesModel({this.message, this.sections, this.semester});

  factory TeacherClassesModel.fromJson(Map<String, dynamic> json) {
    Sections? parsed;
    final rawSections = json['sections'];
    if (rawSections == null) {
      parsed = null;
    } else if (rawSections is Map<String, dynamic>) {
      parsed = Sections.fromJson(rawSections);
    } else if (rawSections is List) {
      parsed = _parseSectionsList(rawSections);
    }
    return TeacherClassesModel(
      message: json['message'] as String?,
      sections: parsed,
      semester: json['semester'] == null
          ? null
          : SemesterModel.fromJson(
              json['semester'] as Map<String, dynamic>,
            ),
    );
  }

  factory TeacherClassesModel.fromList(List<dynamic> list) {
    return TeacherClassesModel(sections: _parseSectionsList(list));
  }

  static Sections _parseSectionsList(List<dynamic> list) {
    final classA = <ClassA>[];
    final classB = <ClassB>[];
    for (final item in list) {
      if (item is! Map<String, dynamic>) continue;
      final section = ClassA.fromJson(item);
      classA.add(section);
    }
    return Sections(classA: classA, classB: classB);
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'sections': sections?.toJson(),
    'semester': semester?.toJson(),
  };

  @override
  List<Object?> get props => [message, sections, semester];
}