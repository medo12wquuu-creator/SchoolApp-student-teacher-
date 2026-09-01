import 'package:flutter/material.dart';

class TaskSubject extends StatelessWidget {
  final String subjectName;
  final Color color;

  const TaskSubject({
    super.key,
    required this.subjectName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      subjectName,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
    );
  }
}
