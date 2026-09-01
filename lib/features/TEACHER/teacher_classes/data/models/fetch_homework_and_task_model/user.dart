import 'package:equatable/equatable.dart';

import 'person.dart';

class User extends Equatable {
  final int? id;
  final String? email;
  final String? phoneNumber;
  final String? status;
  final int? roleId;
  final dynamic emailVerificationCode;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Person? person;

  const User({
    this.id,
    this.email,
    this.phoneNumber,
    this.status,
    this.roleId,
    this.emailVerificationCode,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.person,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int?,
    email: json['email'] as String?,
    phoneNumber: json['phone_number'] as String?,
    status: json['status'] as String?,
    roleId: json['role_id'] as int?,
    emailVerificationCode: json['email_verification_code'] as dynamic,
    emailVerifiedAt: json['email_verified_at'] == null
        ? null
        : DateTime.parse(json['email_verified_at'] as String),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    person: json['person'] == null
        ? null
        : Person.fromJson(json['person'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'phone_number': phoneNumber,
    'status': status,
    'role_id': roleId,
    'email_verification_code': emailVerificationCode,
    'email_verified_at': emailVerifiedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'person': person?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      email,
      phoneNumber,
      status,
      roleId,
      emailVerificationCode,
      emailVerifiedAt,
      createdAt,
      updatedAt,
      person,
    ];
  }
}
