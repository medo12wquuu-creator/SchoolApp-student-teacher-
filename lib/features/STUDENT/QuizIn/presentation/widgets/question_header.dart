import 'package:flutter/material.dart';
import 'question_number_badge.dart';
import 'question_points.dart';

class QuestionHeader extends StatelessWidget {
  final int order;
  final int total;
  final num marks;

  const QuestionHeader({
    super.key,
    required this.order,
    required this.total,
    required this.marks,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuestionNumberBadge(order: order, total: total),
        QuestionPoints(marks: marks),
      ],
    );
  }
}
