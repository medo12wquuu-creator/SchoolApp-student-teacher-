import 'package:equatable/equatable.dart';

class Section extends Equatable {
  final int? id;
  final String? name;
  final int? classroomId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Section({
    this.id,
    this.name,
    this.classroomId,
    this.createdAt,
    this.updatedAt,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json['id'] as int?,
    name: json['name'] as String?,
    classroomId: json['classroom_id'] as int?,
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
    'classroom_id': classroomId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props {
    return [id, name, classroomId, createdAt, updatedAt];
  }
}
