import 'package:flutter/material.dart';

class OutChatMessagePreview extends StatelessWidget {
  final String message;

  const OutChatMessagePreview({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.grey[600], fontSize: 14),
    );
  }
}
