import 'package:flutter/material.dart';
import 'announcement_title.dart';
import 'announcement_description.dart';
import 'announcement_date.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnnouncementTitle(title: title),
            const SizedBox(height: 4),
            AnnouncementDate(date: date),
            const SizedBox(height: 8),
            AnnouncementDescription(description: description),
          ],
        ),
      ),
    );
  }
}
