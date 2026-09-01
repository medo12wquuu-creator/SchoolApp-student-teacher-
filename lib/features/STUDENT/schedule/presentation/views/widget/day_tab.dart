import 'package:flutter/material.dart';

class DayTab extends StatelessWidget {
  final String day;
  final bool isActive;
  final VoidCallback onTap;

  const DayTab({
    super.key,
    required this.day,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveBg = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final inactiveBorder = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    final inactiveText = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E88E5) : inactiveBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? const Color(0xFF1E88E5) : inactiveBorder,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF1E88E5).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          day,
          style: TextStyle(
            color: isActive ? Colors.white : inactiveText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
