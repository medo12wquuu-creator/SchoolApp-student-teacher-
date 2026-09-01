import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';
 
class QuizzesStatusBadge extends StatelessWidget {
  final QuizStatus status;

  const QuizzesStatusBadge({super.key, required this.status});

  static Color borderColor(QuizStatus status) {
    return switch (status) {
      QuizStatus.draft => const Color(0xffFBBF24),
      QuizStatus.closed => Colors.grey.shade400,
      QuizStatus.published => const Color(0xff34D399),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (
      Color bgColor,
      Color textColor,
      String label,
      IconData icon,
    ) = switch (status) {
      QuizStatus.draft => (
        const Color(0xffFEF3C7),
        const Color(0xffD97706),
        'معلق',
        Icons.hourglass_empty_rounded,
      ),
      QuizStatus.closed => (
        Colors.grey.shade200,
        Colors.grey.shade700,
        'مغلق',
        Icons.lock_clock_outlined,
      ),
      QuizStatus.published => (
        const Color(0xffD1FAE5),
        const Color(0xff059669),
        'مرسل',
        Icons.check_circle_outline,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}