import 'package:flutter/material.dart';

class TaskTeacher extends StatelessWidget {
  final String teacherName;

  const TaskTeacher({super.key, required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.person_outline, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          teacherName,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
