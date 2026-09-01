import 'package:flutter/material.dart';

class AnnouncementTitle extends StatelessWidget {
  final String title;

  const AnnouncementTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title, // هنا تضع ال title القادم من الباك
      style: const TextStyle(
        color: Color(0xFF1565C0),
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );
  }
}
