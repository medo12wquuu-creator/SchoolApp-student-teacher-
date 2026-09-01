import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class QuizDetailsRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const QuizDetailsRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: kprimeryColor.withOpacity(0.7)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: ktextColor, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}