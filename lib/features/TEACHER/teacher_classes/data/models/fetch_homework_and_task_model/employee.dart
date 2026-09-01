import 'package:equatable/equatable.dart';

import 'user.dart';

class Employee extends Equatable {
  final int? id;
  final String? hireDate;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  const Employee({
    this.id,
    this.hireDate,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json['id'] as int?,
    hireDate: json['hire_date'] as String?,
    userId: json['user_id'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'hire_date': hireDate,
    'user_id': userId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'user': user?.toJson(),
  };

  @override
  List<Object?> get props {
    return [id, hireDate, userId, createdAt, updatedAt, user];
  }
}
