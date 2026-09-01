import 'package:equatable/equatable.dart';

class Exam extends Equatable {
  final int? id;
  final String? title;
  final String? status;
  final String? startsAt;
  final String? endsAt;

  const Exam({this.id, this.title, this.status, this.startsAt, this.endsAt});

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
    id: _toInt(json['id']),
    title: json['title'] as String?,
    status: json['status'] as String?,
    startsAt: json['starts_at'] as String?,
    endsAt: json['ends_at'] as String?,
  );

  /// تحويل القيمة الرقمية حتى لو وصلت من الباك كنص (String)
  static int? _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'status': status,
    'starts_at': startsAt,
    'ends_at': endsAt,
  };

  @override
  List<Object?> get props => [id, title, status, startsAt, endsAt];
}
