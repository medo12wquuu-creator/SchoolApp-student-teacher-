import 'dart:io';

import 'package:schooly/core/constants/api_constants.dart';

class StudentProfileModel {
  final int id;
  final String email;
  final String? phoneNumber;
  final String? status;
  final int? roleId;

  // Person fields
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? motherName;
  final String? fatherName;
  final String? birthdate;
  final File? personalPhoto;
  final String? personalPhotoUrl;

  // Student related
  final String? classWanted;
  final String? lastClassCertification;
  final String? sectionName;
  final String? classroomName;
  final String? major;
  final String? gpa;

  final String role;

  StudentProfileModel({
    required this.id,
    required this.email,
    this.phoneNumber,
    this.status,
    this.roleId,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.motherName,
    this.fatherName,
    this.birthdate,
    this.personalPhoto,
    this.personalPhotoUrl,
    this.classWanted,
    this.lastClassCertification,
    this.sectionName,
    this.classroomName,
    this.major,
    this.gpa,
    required this.role,
  });

  String get name {
    final parts = [firstName, middleName, lastName]
        .where((s) => s != null && s.trim().isNotEmpty)
        .map((s) => s!.trim())
        .toList();
    return parts.join(' ');
  }

  /// Returns only first and last name (no middle name) for compact display
  String get firstLastName {
    final parts = [
      firstName,
      lastName,
    ].where((s) => s.trim().isNotEmpty).map((s) => s.trim()).toList();
    return parts.join(' ');
  }

  String? get avatarPath => personalPhoto?.path;
  String? get cleanPhotoUrl {
    final raw = personalPhotoUrl;
    if (raw == null || raw.trim().isEmpty) return null;
    final origin = ApiConstants.baseUrl.replaceAll(RegExp(r'/api/?$'), '');

    final value = raw.trim();
    final idx = value.lastIndexOf('/storage/');
    if (idx != -1) {
      final path = value.substring(idx + '/storage/'.length);
      return '$origin/storage/$path';
    }

    final stripped = value
        .replaceFirst(RegExp(r'^https?://[^/]+'), '')
        .replaceFirst(RegExp(r'^/'), '');
    return stripped.startsWith('storage/')
        ? '$origin/$stripped'
        : '$origin/storage/$stripped';
  }

  String? get birthDate => birthdate;

  String? get phone => phoneNumber;

  String? get motherNameSafe => motherName;

  factory StudentProfileModel.fromJson(
    Map<String, dynamic> json, {
    File? downloadedPhoto,
    String? downloadedPhotoUrl,
  }) {
    // The backend sometimes nests person and student under the root
    final person = (json['person'] is Map)
        ? Map<String, dynamic>.from(json['person'])
        : null;
    final student = (json['student'] is Map)
        ? Map<String, dynamic>.from(json['student'])
        : null;

    final personMap = person ?? json;

    final personalPhotoValue =
        personMap['personal_photo'] ?? personMap['personalPhoto'];

    File? personalPhotoFile = downloadedPhoto;
    if (personalPhotoFile == null && personalPhotoValue != null) {
      if (personalPhotoValue is File) {
        personalPhotoFile = personalPhotoValue;
      }
    }

    return StudentProfileModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString(),
      status: json['status']?.toString(),
      roleId: json['role_id'] is int
          ? json['role_id']
          : int.tryParse(json['role_id']?.toString() ?? ''),
      firstName:
          personMap['first_name']?.toString() ??
          personMap['firstName']?.toString() ??
          '',
      lastName:
          personMap['last_name']?.toString() ??
          personMap['lastName']?.toString() ??
          '',
      middleName:
          personMap['middle_name']?.toString() ??
          personMap['middleName']?.toString(),
      motherName:
          personMap['mother_name']?.toString() ??
          personMap['motherName']?.toString(),
      fatherName:
          personMap['father_name']?.toString() ??
          personMap['fatherName']?.toString() ??
          personMap['middle_name']?.toString() ??
          personMap['middleName']?.toString(),
      birthdate: personMap['birthdate']?.toString(),
      personalPhoto: personalPhotoFile,
      personalPhotoUrl: downloadedPhoto == null
          ? personMap['personal_photo']?.toString() ??
                personMap['personalPhoto']?.toString()
          : null,
      classWanted:
          student?['classWanted']?.toString() ??
          student?['class_wanted']?.toString(),
      lastClassCertification: student?['last_class_certification']?.toString(),
      sectionName: student != null && student['section'] is Map
          ? student['section']['name']?.toString()
          : null,
      classroomName:
          student != null &&
              student['section'] is Map &&
              student['section']['classroom'] is Map
          ? student['section']['classroom']['name']?.toString()
          : null,
      role: json['role']?.toString() ?? 'student',
      major: student?['major']?.toString() ?? json['major']?.toString(),
      gpa: student?['gpa']?.toString() ?? json['gpa']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone_number': phoneNumber,
      'status': status,
      'role_id': roleId,
      'person': {
        'first_name': firstName,
        'last_name': lastName,
        'middle_name': middleName,
        'mother_name': motherName,
        'father_name': fatherName,
        'birthdate': birthdate,
        'personal_photo': personalPhoto?.path ?? personalPhotoUrl,
      },
      'student': {
        'classWanted': classWanted,
        'last_class_certification': lastClassCertification,
        'section': {
          'name': sectionName,
          'classroom': {'name': classroomName},
        },
      },
      'role': role,
    };
  }
}
