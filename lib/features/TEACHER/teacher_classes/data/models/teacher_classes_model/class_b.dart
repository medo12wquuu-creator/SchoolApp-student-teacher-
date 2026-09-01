import 'package:equatable/equatable.dart';

import 'classroom.dart';
import 'pivot.dart';

class ClassB extends Equatable {
  final int? id;
  final String? name;
  final int? classroomId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Pivot? pivot;
  final Classroom? classroom;

  const ClassB({
    this.id,
    this.name,
    this.classroomId,
    this.createdAt,
    this.updatedAt,
    this.pivot,
    this.classroom,
  });

  factory ClassB.fromJson(Map<String, dynamic> json) => ClassB(
    id: json['id'] is num
        ? (json['id'] as num).toInt()
        : int.tryParse(json['id']?.toString() ?? ''),
    name: json['name'] as String?,
    classroomId: json['classroom_id'] is num
        ? (json['classroom_id'] as num).toInt()
        : int.tryParse(json['classroom_id']?.toString() ?? ''),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    pivot: json['pivot'] == null
        ? null
        : Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
    classroom: json['classroom'] == null
        ? null
        : Classroom.fromJson(json['classroom'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'classroom_id': classroomId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'pivot': pivot?.toJson(),
    'classroom': classroom?.toJson(),
  };

  @override
  List<Object?> get props {
    return [id, name, classroomId, createdAt, updatedAt, pivot, classroom];
  }
}
