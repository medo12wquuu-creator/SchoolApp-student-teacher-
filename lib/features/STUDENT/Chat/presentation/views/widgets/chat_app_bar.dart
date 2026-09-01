import 'dart:io';

import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final File? imageFile;
  final bool isOnline;

  const ChatAppBar({
    super.key,
    required this.name,
    required this.imageUrl,
    this.imageFile,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final primary = Theme.of(context).colorScheme.primary;
    final appBarBg = isDark ? const Color(0xFF1A1C1E) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1C1B1F);

    return AppBar(
      elevation: 0.5,
      backgroundColor: appBarBg,
      leadingWidth: 40,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Color.fromARGB(162, 56, 1, 123),
        ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color.fromARGB(162, 56, 1, 123),
            backgroundImage: imageFile != null
                ? FileImage(imageFile!)
                : (imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null),
            child: imageFile == null && imageUrl.isEmpty
                ? const Icon(Icons.person, size: 18)
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
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
