import 'package:flutter/material.dart';

class ScheduleItem extends StatelessWidget {
  final int subjectId;
  final String subjectName;
  final String teacherName;
  final String startTime;
  final Color accent;
  final VoidCallback onPressed;

  const ScheduleItem({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.teacherName,
    required this.startTime,
    required this.accent,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final idColor = isDark ? Colors.grey.shade500 : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 60,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subjectName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "#$subjectId",
                        style: TextStyle(
                          fontSize: 11,
                          color: idColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    teacherName,
                    style: TextStyle(
                      fontSize: 13,
                      color: subColor,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              startTime,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
