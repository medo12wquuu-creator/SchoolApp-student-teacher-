import 'package:flutter/material.dart';

class ClassReportsEmptyStateFooter extends StatelessWidget {
  const ClassReportsEmptyStateFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.folder_open, color: Colors.grey[500], size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          'لا توجد المزيد من التقارير لليوم',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }
}
