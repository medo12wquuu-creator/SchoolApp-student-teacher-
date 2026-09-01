import 'package:equatable/equatable.dart';

class ClassReportModel extends Equatable {
  final int? id;
  final int? teacherId;
  final int? studentId;
  final int? sectionId;
  final String? title;
  final String? description;
  final String? status;
  final String? type;
  final bool isAnonymous;
  final DateTime? createdAt;
  final StudentInfo? student;

  const ClassReportModel({
    this.id,
    this.teacherId,
    this.studentId,
    this.sectionId,
    this.title,
    this.description,
    this.status,
    this.type,
    this.isAnonymous = false,
    this.createdAt,
    this.student,
  });

  factory ClassReportModel.fromJson(Map<String, dynamic> json) {
    final studentJson = json['student'];
    return ClassReportModel(
      id: json['id'] as int?,
      teacherId: json['teacher_id'] as int?,
      studentId: json['student_id'] as int?,
      sectionId: json['section_id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      type: json['type'] as String?,
      isAnonymous:
          json['is_anonymous'] == true ||
          (json['status_anonymous'] as String?) == 'anonymous',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
      student: studentJson is Map<String, dynamic>
          ? StudentInfo.fromJson(studentJson)
          : null,
    );
  }

  String get studentName {
    if (student != null && student!.name.isNotEmpty) {
      return student!.name;
    }
    return isAnonymous ? 'بلاغ غير موقع / ولي أمر' : 'أستاذ المادة';
  }

  @override
  List<Object?> get props => [
    id,
    teacherId,
    studentId,
    sectionId,
    title,
    description,
    status,
    type,
    isAnonymous,
    createdAt,
    student,
  ];
}

class StudentInfo extends Equatable {
  final int? id;
  final String name;

  const StudentInfo({this.id, required this.name});

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    final person = json['person'];
    String name = '';
    if (person is Map<String, dynamic>) {
      final fn = (person['first_name'] as String?) ?? '';
      final ln = (person['last_name'] as String?) ?? '';
      name = '$fn $ln'.trim();
    }
    return StudentInfo(id: json['id'] as int?, name: name);
  }

  @override
  List<Object?> get props => [id, name];
}
