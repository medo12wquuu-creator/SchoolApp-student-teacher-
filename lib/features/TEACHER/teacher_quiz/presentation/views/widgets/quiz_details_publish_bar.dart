import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class QuizDetailsPublishBar extends StatelessWidget {
  final bool publishing;
  final VoidCallback onPressed;

  const QuizDetailsPublishBar({
    super.key,
    required this.publishing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: publishing ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: kadditionalColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: publishing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: kwhiteColor,
                    ),
                  )
                : const Icon(Icons.send_rounded, color: kwhiteColor),
            label: const Text(
              'نشر الكويز',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kwhiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}