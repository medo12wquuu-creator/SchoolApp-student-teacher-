import 'package:flutter/material.dart';

class TaskDescription extends StatelessWidget {
  final String description;

  const TaskDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
    );
  }
}
