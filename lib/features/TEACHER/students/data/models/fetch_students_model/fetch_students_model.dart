import 'package:equatable/equatable.dart';
import 'grade.dart';

class FetchStudentsModel extends Equatable {
  final int? id;
  final String? name;
  final String? personalPhoto;
  final List<Grade>? grades;
  final int? total;
  final int? maxTotal;

  const FetchStudentsModel({
    this.id,
    this.name,
    this.personalPhoto,
    this.grades,
    this.total,
    this.maxTotal,
  });

  factory FetchStudentsModel.fromJson(Map<String, dynamic> json) {
    return FetchStudentsModel(
      // 🟢 تأمين الـ ints في مودل الطالب + دعم مفتاح student_id أيضاً
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : json['student_id'] is num
          ? (json['student_id'] as num).toInt()
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] as String? ?? json['student_name'] as String?,
      personalPhoto:
          json['personal_photo'] as String? ??
          json['photo'] as String? ??
          json['avatar'] as String?,
      grades: (json['grades'] as List<dynamic>?)
          ?.map((e) => Grade.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] is num
          ? (json['total'] as num).toInt()
          : int.tryParse(json['total']?.toString() ?? ''),
      maxTotal: json['max_total'] is num
          ? (json['max_total'] as num).toInt()
          : int.tryParse(json['max_total']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'personal_photo': personalPhoto,
    'grades': grades?.map((e) => e.toJson()).toList(),
    'total': total,
    'max_total': maxTotal,
  };

  @override
  List<Object?> get props {
    return [id, name, personalPhoto, grades, total, maxTotal];
  }
}
