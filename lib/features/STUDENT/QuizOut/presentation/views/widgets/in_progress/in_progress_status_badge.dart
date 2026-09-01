
import 'package:flutter/material.dart';

class InProgressStatusBadge extends StatelessWidget {
  const InProgressStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'قيد الحل',
        style: TextStyle(
          color: Color(0xFF1E88E5),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
