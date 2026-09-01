import 'package:equatable/equatable.dart';

import 'pivot.dart';

class Section extends Equatable {
  final int? id;
  final String? name;
  final int? classroomId;
  final int? capacity;
  final String? createdAt;
  final String? updatedAt;
  final Pivot? pivot;

  const Section({
    this.id,
    this.name,
    this.classroomId,
    this.capacity,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json['id'] as int?,
    name: json['name'] as String?,
    classroomId: json['classroom_id'] as int?,
    capacity: json['capacity'] as int?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    pivot: json['pivot'] == null
        ? null
        : Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'classroom_id': classroomId,
    'capacity': capacity,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'pivot': pivot?.toJson(),
  };

  @override
  List<Object?> get props {
    return [id, name, classroomId, capacity, createdAt, updatedAt, pivot];
  }
}
