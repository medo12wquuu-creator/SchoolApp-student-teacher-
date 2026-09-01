// import 'package:equatable/equatable.dart';

// class User extends Equatable {
//   final int? id;
//   final String? email;
//   final String? phoneNumber;
//   final String? status;
//   final int? roleId;
//   final dynamic emailVerificationCode;
//   final DateTime? emailVerifiedAt;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   const User({
//     this.id,
//     this.email,
//     this.phoneNumber,
//     this.status,
//     this.roleId,
//     this.emailVerificationCode,
//     this.emailVerifiedAt,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'] is int
//           ? json['id'] as int?
//           : int.tryParse(json['id'].toString()),

//       email: json['email']?.toString(),

//       // تأمين رقم الهاتف الضخم: نتحقق أولاً لمنع الكراش الناتيف
//       phoneNumber: json['phone_number']?.toString(),

//       status: json['status']?.toString(),

//       roleId: json['role_id'] is int
//           ? json['role_id'] as int?
//           : int.tryParse(json['role_id'].toString()),

//       emailVerificationCode: json['email_verification_code'],

//       emailVerifiedAt: json['email_verified_at'] != null
//           ? DateTime.tryParse(json['email_verified_at'].toString())
//           : null,

//       createdAt: json['created_at'] != null
//           ? DateTime.tryParse(json['created_at'].toString())
//           : null,

//       updatedAt: json['updated_at'] != null
//           ? DateTime.tryParse(json['updated_at'].toString())
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'email': email,
//     'phone_number': phoneNumber,
//     'status': status,
//     'role_id': roleId,
//     'email_verification_code': emailVerificationCode,
//     'email_verified_at': emailVerifiedAt?.toIso8601String(),
//     'created_at': createdAt?.toIso8601String(),
//     'updated_at': updatedAt?.toIso8601String(),
//   };

//   @override
//   // الحل السحري: نكتفي بمقارنة الحقول الأساسية الفريدة لتخفيف العبء عن المعالج ومنع الـ Infinite Loops
//   List<Object?> get props => [id, email, status, roleId];
// }
