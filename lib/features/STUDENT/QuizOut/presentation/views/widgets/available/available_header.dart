
import 'package:flutter/material.dart';
import 'available_status_badge.dart';

class AvailableHeader extends StatelessWidget {
  final String subject;
  final String teacher;

  const AvailableHeader({
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
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.quiz_outlined, color: Color(0xFF2E7D32)),
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
        const AvailableStatusBadge(),
      ],
    );
  }
}
