import 'package:flutter/material.dart';

class QuestionPoints extends StatelessWidget {
  final num marks;

  const QuestionPoints({super.key, required this.marks});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.stars_outlined, size: 16, color: Color(0xFF6B7280)),
        const SizedBox(width: 4),
        Text(
          '${_formatMarks(marks)} علامة',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatMarks(num m) {
    if (m == m.roundToDouble()) return m.toInt().toString();
    return m.toStringAsFixed(1);
  }
}
