import 'package:flutter/material.dart';
import 'package:schooly/features/STUDENT/AllTasks/data/models/task_model.dart';
import 'task_accent_bar.dart';
import 'task_deadline.dart';
import 'task_description.dart';
import 'task_subject.dart';
import 'task_teacher.dart';
import 'task_type_badge.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TaskAccentBar(color: task.accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TaskSubject(
                            subjectName: task.subjectName,
                            color: task.accent,
                          ),
                        ),
                        TaskTypeBadge(type: task.type),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TaskDescription(description: task.description),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TaskTeacher(teacherName: task.teacherName),
                        TaskDeadline(deliveryDate: task.deliveryDate),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
