
import 'package:flutter/material.dart';

class CompletedStatusBadge extends StatelessWidget {
  const CompletedStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'تم الاكمال',
        style: TextStyle(
          color: Color(0xFF6D28D9),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
