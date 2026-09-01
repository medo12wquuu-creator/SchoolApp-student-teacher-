
import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class ClassDetailsSectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onTapAction;

  const ClassDetailsSectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // شريط ملون بسيط بنفس لون التطبيق
            Container(
              width: 5,
              height: 20,
              decoration: BoxDecoration(
                color: kprimeryColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kDarkPrimaryColor,
              ),
            ),
          ],
        ),
        if (actionText.isNotEmpty)
          GestureDetector(
            onTap: onTapAction,
            child: Text(
              actionText,
              style: const TextStyle(
                color: kprimeryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}
