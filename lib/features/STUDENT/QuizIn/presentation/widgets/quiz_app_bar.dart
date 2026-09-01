import 'package:flutter/material.dart';
import 'quiz_timer.dart';

class QuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int remainingSeconds;
  final VoidCallback? onTimeExpired;

  const QuizAppBar({
    super.key,
    required this.title,
    required this.remainingSeconds,
    this.onTimeExpired,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xFF1E88E5),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: QuizTimer(
              initialSeconds: remainingSeconds,
              onExpired: onTimeExpired,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFD8DADD)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
