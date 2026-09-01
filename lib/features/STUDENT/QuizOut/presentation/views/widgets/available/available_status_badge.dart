
import 'package:flutter/material.dart';

class AvailableStatusBadge extends StatelessWidget {
  const AvailableStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'متاح',
        style: TextStyle(
          color: Color(0xFF2E7D32),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
