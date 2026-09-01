import 'package:flutter/material.dart';

class UpcomingStatusBadge extends StatelessWidget {
  const UpcomingStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'UPCOMING',
        style: TextStyle(
          color: Color(0xFF4B5563),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
