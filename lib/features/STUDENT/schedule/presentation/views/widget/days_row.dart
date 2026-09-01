import 'package:flutter/material.dart';
import 'day_tab.dart';

class DaysRow extends StatelessWidget {
  final String selectedDay;
  final Function(String) onDaySelected;

  const DaysRow({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: days.map((day) {
          return DayTab(
            day: day,
            isActive: selectedDay == day,
            onTap: () => onDaySelected(day),
          );
        }).toList(),
      ),
    );
  }
}
