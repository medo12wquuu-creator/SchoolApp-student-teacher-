
import 'package:flutter/material.dart';

class AvailableStatistics extends StatelessWidget {
  final int questions;
  final int totalMarks;
  final int minutes;

  const AvailableStatistics({
    super.key,
    required this.questions,
    required this.totalMarks,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(
          icon: Icons.question_answer_outlined,
          value: '$questions',
          label: 'الأسئلة',
        ),
        _StatItem(
          icon: Icons.stars_outlined,
          value: '$totalMarks',
          label: 'العلامة الكلية',
        ),
        _StatItem(
          icon: Icons.timer_outlined,
          value: '$minutes',
          label: 'الدقائق',
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}
