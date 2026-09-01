import 'package:equatable/equatable.dart';

/// الفصل الدراسي الحالي للمعلم (يأتي من استجابة /teacherSections)
class SemesterModel extends Equatable {
  final int? id;
  final int? academicYearId;
  final String? name;
  final String? startDate;
  final String? endDate;

  const SemesterModel({
    this.id,
    this.academicYearId,
    this.name,
    this.startDate,
    this.endDate,
  });

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : int.tryParse(json['id']?.toString() ?? ''),
      academicYearId: json['academic_year_id'] is num
          ? (json['academic_year_id'] as num).toInt()
          : int.tryParse(json['academic_year_id']?.toString() ?? ''),
      name: json['name'] as String?,
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'academic_year_id': academicYearId,
    'name': name,
    'start_date': startDate,
    'end_date': endDate,
  };

  @override
  List<Object?> get props {
    return [id, academicYearId, name, startDate, endDate];
  }
}