import 'package:flutter/material.dart';
 import 'package:schooly/features/TEACHER/teacher_chat_room/data/models/message_model.dart';

class IncomingMessageBubble extends StatelessWidget {
  final MessageModel message;

  const IncomingMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 16, right: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الرسالة نفسها
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E2E6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: const TextStyle(fontSize: 15, color: Color(0xFF1C1B1F)),
              ),
            ),

            // الوقت
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: 1,
                child: Text(
                  message.time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF939094),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
