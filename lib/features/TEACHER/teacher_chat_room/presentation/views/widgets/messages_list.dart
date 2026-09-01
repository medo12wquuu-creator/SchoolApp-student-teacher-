import 'package:flutter/material.dart';
 import 'package:schooly/features/TEACHER/teacher_chat_room/data/models/message_model.dart';

import 'incoming_message_bubble.dart';
import 'outgoing_message_bubble.dart';

class MessagesList extends StatelessWidget {
  final List<MessageModel> messages;
  final ScrollController controller;

  const MessagesList({
    super.key,
    required this.messages,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        // عنوان اليوم
        if (index == 0) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                'TODAY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF939094),
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        }

        final message = messages[index - 1];

        return message.isMine
            ? OutgoingMessageBubble(message: message)
            : IncomingMessageBubble(message: message);
      },
    );
  }
}
