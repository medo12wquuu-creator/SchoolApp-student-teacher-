import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isOnline;

  const ChatAppBar({
    super.key,
    required this.name,
    required this.imageUrl,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      leadingWidth: 40,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF007AFF)),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE2E8F0),
            foregroundImage: imageUrl.isEmpty ? null : NetworkImage(imageUrl),
            onForegroundImageError: imageUrl.isEmpty ? null : (_, _) {},
            child: imageUrl.isEmpty
                ? Text(
                    name.isEmpty ? '؟' : name[0],
                    style: const TextStyle(
                      color: Color(0xFF000865),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1B1F),
                ),
              ),
              Text(
                isOnline ? 'ONLINE' : 'OFFLINE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isOnline ? Colors.green.shade700 : Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
