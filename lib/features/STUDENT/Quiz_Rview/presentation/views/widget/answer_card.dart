
import 'package:flutter/material.dart';

class AnswerCard extends StatelessWidget {
  const AnswerCard({
    super.key,
    required this.label,
    required this.answer,
    required this.isCorrect,
    required this.icon,
  });

  final String label;
  final String? answer;
  final bool isCorrect;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final Color mainColor = isCorrect
        ? const Color(0xFF2ECC71)
        : const Color(0xFFE74C3C);

    final Color backgroundColor = isCorrect
        ? const Color(0xFFF1FBF5)
        : const Color(0xFFFFF5F5);

    final Color borderColor = isCorrect
        ? const Color(0xFFB5E8C8)
        : const Color(0xFFFFB8B8);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Icon(icon, color: mainColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  answer ?? 'لم تتم الإجابة',
                  style: const TextStyle(
                    color: Color(0xFF172B4D),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
            child: Icon(
              isCorrect ? Icons.check_rounded : Icons.close_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
