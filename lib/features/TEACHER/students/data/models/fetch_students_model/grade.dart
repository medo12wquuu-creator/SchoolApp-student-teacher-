import 'package:equatable/equatable.dart';

class Grade extends Equatable {
  final int? weightId;
  final String? type;
  final String? maxScore;
  final String? score;

  const Grade({this.weightId, this.type, this.maxScore, this.score});

  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
    // 🟢 تحويل آمن للـ weight_id من double/int إلى int
    weightId: json['weight_id'] is num
        ? (json['weight_id'] as num).toInt()
        : int.tryParse(json['weight_id']?.toString() ?? ''),
    type: json['type'] as String?,
    // 🟢 تحويل آمن لـ String منعاً للتعارض
    maxScore: json['max_score']?.toString(),
    score: json['score']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'weight_id': weightId,
    'type': type,
    'max_score': maxScore,
    'score': score,
  };

  @override
  List<Object?> get props => [weightId, type, maxScore, score];
}
