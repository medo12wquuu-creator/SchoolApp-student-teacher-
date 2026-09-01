import 'package:flutter/material.dart';
import '../../../data/models/outchat_model.dart';
import 'outchat_avatar.dart';
import 'outchat_message_preview.dart';
import 'outchat_time.dart';
import 'outchat_title.dart';
import 'outchat_unreadbadge.dart';

class OutChatTile extends StatelessWidget {
  final OutChatModel conversation;
  final VoidCallback? onTap;

  const OutChatTile({super.key, required this.conversation, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: OutChatAvatar(
        imageUrl: conversation.otherUserImage,
        file: conversation.personalPhotoFile,
      ),
      title: OutChatTitle(name: conversation.otherUserName),
      subtitle: OutChatMessagePreview(message: conversation.lastMessage),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          OutChatTime(time: conversation.lastMessageTime),
          const SizedBox(height: 4),
          OutChatUnreadBadge(count: conversation.unreadCount),
        ],
      ),
    );
  }
}
