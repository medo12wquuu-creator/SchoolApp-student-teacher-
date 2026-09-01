import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String subject;
  final String teacherName;
  final String time;
  final Color accent;

  const ClassCard({
    super.key,
    required this.subject,
    required this.teacherName,
    required this.time,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF333333);
    final subColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;
    final timeColor = isDark ? Colors.grey.shade500 : Colors.grey.shade600;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            teacherName,
            style: TextStyle(fontSize: 14, color: subColor),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(color: timeColor, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
