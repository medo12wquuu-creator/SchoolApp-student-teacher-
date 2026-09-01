
import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class ClassDetailsActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color? iconColor;

  const ClassDetailsActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: effectiveIconColor.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: effectiveIconColor.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kwhiteColor.withOpacity(0.85),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 26, color: effectiveIconColor),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
              color: effectiveIconColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
