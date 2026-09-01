import 'package:equatable/equatable.dart';
import 'user.dart';

class Student extends Equatable {
  final int? id;
  final int? userId;
  final String? classWanted;
  final String? lastClassCertification;
  final String? firstName; // 🟢 أُضيفت لدعم الباك إند الحالي
  final String? lastName; // 🟢 أُضيفت لدعم الباك إند الحالي
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  const Student({
    this.id,
    this.userId,
    this.classWanted,
    this.lastClassCertification,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    // 🟢 يقرأ student_id أولاً ثم id إذا وجده
    id: (json['student_id'] ?? json['id']) as int?,
    userId: json['user_id'] as int?,
    classWanted: json['classWanted'] as String?,
    lastClassCertification: json['last_class_certification'] as String?,
    // 🟢 قراءة الأسماء المباشرة من الباك إند
    firstName: json['student_FirstName'] as String?,
    lastName: json['student_LastName'] as String?,
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
    'student_id': id,
    'user_id': userId,
    'classWanted': classWanted,
    'last_class_certification': lastClassCertification,
    'student_FirstName': firstName,
    'student_LastName': lastName,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'user': user?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      classWanted,
      lastClassCertification,
      firstName,
      lastName,
      createdAt,
      updatedAt,
      user,
    ];
  }
}
