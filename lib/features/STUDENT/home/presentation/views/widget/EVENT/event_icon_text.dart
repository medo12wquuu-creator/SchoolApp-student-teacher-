import 'package:flutter/material.dart';

class EventIconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const EventIconText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1E88E5)),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF44474E),
          ),
        ),
      ],
    );
  }
}
