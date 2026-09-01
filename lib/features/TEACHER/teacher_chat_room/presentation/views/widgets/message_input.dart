import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  final VoidCallback onSend;

  const MessageInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),

      child: Row(
        children: [
          /// Attachment Button
          IconButton(
            onPressed: () {
              // لاحقاً:
              // اختيار صورة
              // اختيار PDF
              // اختيار ملف
            },
            icon: const Icon(Icons.add, size: 28, color: Color(0xFF007AFF)),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F3F8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFDAD9DF)),
              ),

              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Color(0xFF939094), fontSize: 15),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          GestureDetector(
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                onSend();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF007AFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
