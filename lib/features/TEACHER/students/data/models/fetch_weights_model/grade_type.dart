import 'package:equatable/equatable.dart';

class GradeType extends Equatable {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GradeType({this.id, this.name, this.createdAt, this.updatedAt});

  factory GradeType.fromJson(Map<String, dynamic> json) => GradeType(
    // 🟢 تحويل آمن لتفادي خطأ الـ double/int
    id: json['id'] is num
        ? (json['id'] as num).toInt()
        : int.tryParse(json['id']?.toString() ?? ''),
    name: json['name'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, createdAt, updatedAt];
}
