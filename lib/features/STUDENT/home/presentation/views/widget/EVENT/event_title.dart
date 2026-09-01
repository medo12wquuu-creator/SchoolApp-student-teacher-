import 'package:flutter/material.dart';

class EventTitle extends StatelessWidget {
  final String title;

  const EventTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title, // هنا اريدك ان تاخذ العنوان الذي تجلبه من الباك وتعرضه هنا بدل العنوان الثابت
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1C1E),
      ),
    );
  }
}
