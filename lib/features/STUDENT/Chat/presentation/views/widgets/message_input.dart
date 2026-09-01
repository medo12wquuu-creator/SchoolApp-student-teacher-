// import 'package:flutter/material.dart';

// class MessageInput extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;

//   final bool showEmoji;

//   final VoidCallback onEmojiPressed;
//   final VoidCallback onSend;

//   const MessageInput({
//     super.key,
//     required this.controller,
//     required this.focusNode,
//     required this.showEmoji,
//     required this.onEmojiPressed,
//     required this.onSend,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.05),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),

//       child: Row(
//         children: [
//           /// Attachment Button
//           IconButton(
//             onPressed: () {
//               // لاحقاً:
//               // اختيار صورة
//               // اختيار PDF
//               // اختيار ملف
//             },
//             icon: const Icon(Icons.add, size: 28, color: Color(0xFF007AFF)),
//           ),

//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF4F3F8),
//                 borderRadius: BorderRadius.circular(24),
//                 border: Border.all(color: const Color(0xFFDAD9DF)),
//               ),

//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: controller,
//                       focusNode: focusNode,
//                       style: const TextStyle(color: Colors.black, fontSize: 15),

//                       onTap: () {
//                         // إذا الإيموجي مفتوح → أغلقه وافتح الكيبورد
//                         if (showEmoji) {
//                           focusNode.requestFocus();
//                         }
//                       },

//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Type a message...",
//                         hintStyle: TextStyle(
//                           color: Color(0xFF939094),
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),

//                   IconButton(
//                     onPressed: () {
//                       // إغلاق الكيبورد عند فتح الإيموجي
//                       FocusScope.of(context).unfocus();
//                       onEmojiPressed();
//                     },
//                     icon: Icon(
//                       showEmoji
//                           ? Icons.keyboard
//                           : Icons.sentiment_satisfied_alt_outlined,
//                       color: const Color(0xFF939094),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(width: 8),

//           GestureDetector(
//             onTap: () {
//               if (controller.text.trim().isNotEmpty) {
//                 onSend();
//               }
//             },
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: const BoxDecoration(
//                 color: Color(0xFF007AFF),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.send, color: Colors.white, size: 20),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  final bool showEmoji;

  final VoidCallback onEmojiPressed;
  final VoidCallback onSend;

  const MessageInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.showEmoji,
    required this.onEmojiPressed,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// Attachment Button
          IconButton(
            onPressed: () {
              // لاحقاً:
              // اختيار صورة
              // اختيار PDF
              // اختيار ملف
            },
            icon: const Icon(
              Icons.add,
              size: 28,
              color: Color.fromARGB(255, 115, 0, 255),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              decoration: BoxDecoration(
                color: const Color(0xFFF4F3F8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFDAD9DF)),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Message TextField
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,

                      style: const TextStyle(color: Colors.black, fontSize: 15),

                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,

                      minLines: 1,
                      maxLines: 5,

                      onTap: () {
                        // إذا الإيموجي مفتوح
                        // نغلقه ونفتح الكيبورد
                        if (showEmoji) {
                          onEmojiPressed();
                        }

                        focusNode.requestFocus();
                      },

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF4F3F8)),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF4F3F8)),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF4F3F8)),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF4F3F8)),
                        ),

                        fillColor: Color(0xFFF4F3F8),

                        hintText: "Type a message...",

                        hintStyle: TextStyle(
                          color: Color(0xFF939094),
                          fontSize: 15,
                        ),

                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),

                  /// Emoji / Keyboard Button
                  IconButton(
                    onPressed: () {
                      if (showEmoji) {
                        // الإيموجي مفتوح
                        // نغلق الإيموجي ونفتح الكيبورد

                        onEmojiPressed();

                        focusNode.requestFocus();
                      } else {
                        // الكيبورد مفتوح
                        // نغلق الكيبورد ونفتح الإيموجي

                        FocusScope.of(context).unfocus();

                        onEmojiPressed();
                      }
                    },

                    icon: Icon(
                      showEmoji
                          ? Icons.keyboard
                          : Icons.sentiment_satisfied_alt_outlined,

                      color: const Color(0xFF939094),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// Send Button
          GestureDetector(
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                onSend();
              }
            },

            child: Container(
              padding: const EdgeInsets.all(10),

              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 115, 0, 255),
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
