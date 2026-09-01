import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final int? id;
  final int? periodNumber;
  final String? startTime;
  final String? endTime;
  final int? isBreak;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TimeSlot({
    this.id,
    this.periodNumber,
    this.startTime,
    this.endTime,
    this.isBreak,
    this.createdAt,
    this.updatedAt,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    id: json['id'] as int?,
    periodNumber: json['period_number'] as int?,
    startTime: json['start_time'] as String?,
    endTime: json['end_time'] as String?,
    isBreak: json['is_break'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'period_number': periodNumber,
    'start_time': startTime,
    'end_time': endTime,
    'is_break': isBreak,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      periodNumber,
      startTime,
      endTime,
      isBreak,
      createdAt,
      updatedAt,
    ];
  }
}
