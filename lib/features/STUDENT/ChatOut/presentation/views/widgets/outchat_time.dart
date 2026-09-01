import 'package:flutter/material.dart';

class OutChatTime extends StatelessWidget {
  final String time;

  const OutChatTime({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 12));
  }
}
