import 'package:flutter/material.dart';

class OutChatTitle extends StatelessWidget {
  final String name;

  const OutChatTitle({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
