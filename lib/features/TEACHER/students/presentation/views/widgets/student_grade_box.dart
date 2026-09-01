import 'package:flutter/material.dart';

class StudentGradeBox extends StatelessWidget {
  final String title;
  final String grade;
  const StudentGradeBox(this.title, this.grade, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasTitle = title.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF4285F4).withOpacity(0.15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasTitle) ...[
            Text(
              title,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
          ],
          Text(
            grade,
            style: TextStyle(
              fontSize: hasTitle ? 12 : 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4285F4),
            ),
          ),
        ],
      ),
    );
  }
}