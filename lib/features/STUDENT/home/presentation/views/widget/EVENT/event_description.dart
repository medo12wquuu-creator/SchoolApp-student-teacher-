import 'package:flutter/material.dart';

class EventDescription extends StatelessWidget {
  final String description;

  const EventDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description, // هنا اريدك ان تاخذ body الذي تجلبه من الباك وتعرضه هنا بدل الوصف الثابت
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
    );
  }
}
