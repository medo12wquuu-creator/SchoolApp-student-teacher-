import 'package:flutter/material.dart';

class TaskDeadline extends StatelessWidget {
  final String deliveryDate;

  const TaskDeadline({super.key, required this.deliveryDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.event_outlined, size: 14, color: Color(0xFF1E88E5)),
        const SizedBox(width: 4),
        Text(
          deliveryDate,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E88E5),
          ),
        ),
      ],
    );
  }
}
