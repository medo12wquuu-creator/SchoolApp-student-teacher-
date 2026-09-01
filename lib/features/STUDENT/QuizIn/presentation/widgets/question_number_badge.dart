import 'package:flutter/material.dart';

class QuestionNumberBadge extends StatelessWidget {
  final int order;
  final int total;

  const QuestionNumberBadge({
    super.key,
    required this.order,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'سؤال $order من $total',
        style: const TextStyle(
          color: Color(0xFF1E88E5),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
