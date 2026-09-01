import 'package:equatable/equatable.dart';

class Attempts extends Equatable {
  final int? total;
  final int? inProgress;
  final int? submitted;
  final int? timeout;

  const Attempts({this.total, this.inProgress, this.submitted, this.timeout});

  factory Attempts.fromJson(Map<String, dynamic> json) => Attempts(
    total: json['total'] as int?,
    inProgress: json['in_progress'] as int?,
    submitted: json['submitted'] as int?,
    timeout: json['timeout'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'total': total,
    'in_progress': inProgress,
    'submitted': submitted,
    'timeout': timeout,
  };

  @override
  List<Object?> get props => [total, inProgress, submitted, timeout];
}
