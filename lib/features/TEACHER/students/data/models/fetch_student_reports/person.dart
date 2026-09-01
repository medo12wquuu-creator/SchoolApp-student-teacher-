import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final int? id;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final dynamic middleName;
  final dynamic motherName;
  final String? birthdate;
  final String? personalPhoto;
  final String? idPhoto;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Person({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.middleName,
    this.motherName,
    this.birthdate,
    this.personalPhoto,
    this.idPhoto,
    this.createdAt,
    this.updatedAt,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    firstName: json['first_name'] as String?,
    lastName: json['last_name'] as String?,
    middleName: json['middle_name'] as dynamic,
    motherName: json['mother_name'] as dynamic,
    birthdate: json['birthdate'] as String?,
    personalPhoto: json['personal_photo'] as String?,
    idPhoto: json['id_photo'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'first_name': firstName,
    'last_name': lastName,
    'middle_name': middleName,
    'mother_name': motherName,
    'birthdate': birthdate,
    'personal_photo': personalPhoto,
    'id_photo': idPhoto,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      firstName,
      lastName,
      middleName,
      motherName,
      birthdate,
      personalPhoto,
      idPhoto,
      createdAt,
      updatedAt,
    ];
  }
}
