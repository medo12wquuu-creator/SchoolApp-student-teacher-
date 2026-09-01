import 'package:equatable/equatable.dart';

import 'student.dart';

class Section extends Equatable {
  final int? sectionId;
  final String? sectionName;
  final List<Student>? students;

  const Section({this.sectionId, this.sectionName, this.students});

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    sectionId: _toInt(json['section_id']),
    sectionName: json['section_name'] as String?,
    students: (json['students'] as List<dynamic>?)
        ?.map((e) => Student.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  /// تحويل القيمة الرقمية حتى لو وصلت من الباك كنص (String)
  static int? _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {
    'section_id': sectionId,
    'section_name': sectionName,
    'students': students?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [sectionId, sectionName, students];
}
