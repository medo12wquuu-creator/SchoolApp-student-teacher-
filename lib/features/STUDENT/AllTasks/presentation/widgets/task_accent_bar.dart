import 'package:flutter/material.dart';

class TaskAccentBar extends StatelessWidget {
  final Color color;

  const TaskAccentBar({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
