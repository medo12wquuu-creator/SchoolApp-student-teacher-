
import 'package:flutter/material.dart';
import 'in_progress_status_badge.dart';

class InProgressHeader extends StatelessWidget {
  final String subject;
  final String teacher;

  const InProgressHeader({
    super.key,
    required this.subject,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.play_circle_outline,
            color: Color(0xFF1E88E5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                teacher,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const InProgressStatusBadge(),
      ],
    );
  }
}
