import 'dart:io';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? avatarUrl;
  final File? avatarFile;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    this.avatarFile,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    // final subtitleColor = isDark
    //     ? Colors.grey.shade400
    //     : const Color(0xFF44474E);

    final ImageProvider? imageProvider;
    if (avatarFile != null) {
      imageProvider = FileImage(avatarFile!);
    } else if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      imageProvider = NetworkImage(avatarUrl!);
    } else {
      imageProvider = null;
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 75,
                backgroundImage: imageProvider,
                backgroundColor: Colors.grey.shade200,
                child: imageProvider == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C1E),
                        ),
                      )
                    : null,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF1E88E5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          name,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: nameColor,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        // const SizedBox(height: 6),
        // Text(
        //   subtitle,
        //   style: TextStyle(
        //     fontSize: 22,
        //     color: subtitleColor,
        //     fontWeight: FontWeight.w500,
        //   ),
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }
}
