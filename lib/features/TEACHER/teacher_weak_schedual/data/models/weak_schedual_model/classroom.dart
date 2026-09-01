import 'package:equatable/equatable.dart';

class Classroom extends Equatable {
  final int? id;
  final String? name;
  final int? stageId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Classroom({
    this.id,
    this.name,
    this.stageId,
    this.createdAt,
    this.updatedAt,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
    id: json['id'] as int?,
    name: json['name'] as String?,
    stageId: json['stage_id'] as int?,
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
    'stage_id': stageId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, stageId, createdAt, updatedAt];
}
