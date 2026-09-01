import 'package:flutter/material.dart';
import '../../../../Grade/presentation/views/grade_page.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool hasViewAll;
  final int? count;
  final VoidCallback? onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.hasViewAll = false,
    this.count,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final badgeBg = isDark ? Colors.grey.shade700 : const Color(0xFFE2E8F0);
    final badgeText = isDark ? Colors.grey.shade300 : const Color(0xFF64748B);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count CLASSES',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeText,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (hasViewAll)
          TextButton(
            onPressed:
                onViewAll ??
                () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const GradePage()));
                },
            child: const Text(
              'عرض الكل',
              style: TextStyle(
                color: Color(0xFF1E88E5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
