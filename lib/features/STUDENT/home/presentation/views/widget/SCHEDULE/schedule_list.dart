import 'package:flutter/material.dart';
import 'schedule_item.dart';

class ScheduleModel {
  final int subjectId;
  final String subjectName;
  final String teacherName;
  final String startTime;
  final Color accent;

  ScheduleModel({
    required this.subjectId,
    required this.subjectName,
    required this.teacherName,
    required this.startTime,
    required this.accent,
  });
}

class ScheduleList extends StatelessWidget {
  final List<ScheduleModel> items;
  final Function(String) onItemPressed;

  const ScheduleList({
    super.key,
    required this.items,
    required this.onItemPressed,
  });

  static const List<Color> _defaultAccents = [
    Color(0xFFF97316),
    Color(0xFF0EA5E9),
    Color(0xFF22C55E),
    Color.fromARGB(255, 249, 249, 22),
    Color(0xFF8B5CF6),
    Color(0xFFE11D48),
    Color(0xFF14B8A6),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        padding: const EdgeInsets.only(bottom: 8),
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          final accent = _defaultAccents[index % _defaultAccents.length];

          return SizedBox(
            width: 260,
            child: ScheduleItem(
              subjectId: item.subjectId,
              subjectName: item.subjectName,
              teacherName: item.teacherName,
              startTime: item.startTime,
              accent: accent,
              onPressed: () => onItemPressed(item.subjectName),
            ),
          );
        },
      ),
    );
  }
}
