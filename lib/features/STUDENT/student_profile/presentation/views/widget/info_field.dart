import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final IconData? leadingIcon;

  const InfoField({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF2F4F6);
    final labelColor = isDark ? Colors.grey.shade400 : const Color(0xFF5E6066);
    final valueColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final iconBg = isDark ? const Color(0xFF1A3A5C) : const Color(0xFFD0E4FF);
    final iconColor = isDark ? const Color(0xFF90CAF9) : const Color(0xFF001D36);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                leadingIcon,
                size: 20,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w800,
                    color: labelColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 16, color: const Color(0xFF1E88E5)),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
