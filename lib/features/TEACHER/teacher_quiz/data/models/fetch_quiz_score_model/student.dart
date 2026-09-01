// import 'package:equatable/equatable.dart';

// class Student extends Equatable {
//   final int? studentId;
//   final String? name;
//   final int? score;
//   final int? total;
//   final int? percentage;
//   final String? status;
//   final String? submittedAt;

//   const Student({
//     this.studentId,
//     this.name,
//     this.score,
//     this.total,
//     this.percentage,
//     this.status,
//     this.submittedAt,
//   });

//   /// تحويل القيمة الرقمية حتى لو وصلت من الباك كنص (String)
//   static int? _toInt(dynamic value) {
//     if (value is num) return value.toInt();
//     return int.tryParse(value?.toString() ?? '');
//   }

//   factory Student.fromJson(Map<String, dynamic> json) => Student(
//     studentId: _toInt(json['student_id']),
//     name: json['name'] as String?,
//     score: _toInt(json['score']),
//     total: _toInt(json['total']),
//     percentage: _toInt(json['percentage']),
//     status: json['status'] as String?,
//     submittedAt: json['submitted_at'] as String?,
//   );

//   Map<String, dynamic> toJson() => {
//     'student_id': studentId,
//     'name': name,
//     'score': score,
//     'total': total,
//     'percentage': percentage,
//     'status': status,
//     'submitted_at': submittedAt,
//   };

//   @override
//   List<Object?> get props {
//     return [studentId, name, score, total, percentage, status, submittedAt];
//   }
// }

import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final int? studentId;
  final String? name;
  final num? score;
  final num? total;
  final num? percentage;
  final String? status;
  final String? submittedAt;

  const Student({
    this.studentId,
    this.name,
    this.score,
    this.total,
    this.percentage,
    this.status,
    this.submittedAt,
  });

  static int? _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static num? _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '');
  }

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    studentId: _toInt(json['student_id']),
    name: json['name'] as String?,
    score: _toNum(json['score']),
    total: _toNum(json['total']),
    percentage: _toNum(json['percentage']),
    status: json['status'] as String?,
    submittedAt: json['submitted_at'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'student_id': studentId,
    'name': name,
    'score': score,
    'total': total,
    'percentage': percentage,
    'status': status,
    'submitted_at': submittedAt,
  };

  @override
  List<Object?> get props {
    return [studentId, name, score, total, percentage, status, submittedAt];
  }
}
