import 'package:flutter/material.dart';
import 'task_card.dart';

class TaskItemModel {
  final String subjectName;
  final String title;
  final String description;
  final String deliveryDate;
  final Color accent;
  final IconData icon;

  TaskItemModel({
    required this.subjectName,
    required this.title,
    required this.description,
    required this.deliveryDate,
    required this.accent,
    required this.icon,
  });
}

class TasksList extends StatelessWidget {
  final List<TaskItemModel> tasks;

  const TasksList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: tasks.map((task) {
          return Row(
            children: [
              TaskCard(
                subjectName: task.subjectName,
                title: task.title,
                description: task.description,
                deliveryDate: task.deliveryDate,
                accent: task.accent,
                icon: task.icon,
              ),
              const SizedBox(width: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
