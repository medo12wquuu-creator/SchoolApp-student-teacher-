import 'dart:io';

import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  final String name;
  final File? avatarFile;
  final String? avatarUrl;

  const GreetingHeader({
    super.key,
    required this.name,
    this.avatarFile,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor = isDark
        ? Colors.grey.shade400
        : const Color(0xFF64748B);

    ImageProvider? provider;
    if (avatarFile != null) {
      provider = FileImage(avatarFile!);
    } else if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      provider = NetworkImage(avatarUrl!);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF93C5FD).withValues(alpha: 0.28),
            const Color(0xFF8B5CF6).withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF93C5FD).withValues(alpha: 0.38),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحبا $name',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "أتمنى لك يوماًً مثمرًا",
                  style: TextStyle(color: subtitleColor, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: provider,
              backgroundColor: Colors.white.withValues(alpha: 0.7),
              child: provider == null
                  ? const Icon(Icons.person, size: 30, color: Colors.grey)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
