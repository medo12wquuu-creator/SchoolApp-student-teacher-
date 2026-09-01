import 'package:flutter/material.dart';

class QuestionText extends StatelessWidget {
  final String body;

  const QuestionText({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Text(
      body,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF172033),
        height: 1.5,
      ),
    );
  }
}
