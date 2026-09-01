
import 'package:flutter/material.dart';
import 'upcoming_status_badge.dart';

class UpcomingHeader extends StatelessWidget {
  final String subject;
  final String teacher;

  const UpcomingHeader({
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
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.schedule_outlined, color: Color(0xFF4B5563)),
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
        const UpcomingStatusBadge(),
      ],
    );
  }
}
