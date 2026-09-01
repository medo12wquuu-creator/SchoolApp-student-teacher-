import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class QuickLinksRow extends StatelessWidget {
  final List<QuickLinkModel> links;
  final Function(String) onLinkPressed;

  const QuickLinksRow({
    super.key,
    required this.links,
    required this.onLinkPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(255, 0, 0, 0);
    final iconColor = const Color.fromARGB(255, 255, 253, 253);
    //  isDark ? Colors.white70 : Colors.black87;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: links.map((link) {
        return Showcase(
          key: link.showcaseKey ?? GlobalKey(),
          title: link.label,
          description:
              link.showcaseDescription ?? 'اضغط للانتقال إلى ${link.label}',
          targetPadding: const EdgeInsets.all(6),
          targetShapeBorder: const CircleBorder(),
          child: InkWell(
            onTap: () => onLinkPressed(link.label),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: link.bgColor,

                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(link.icon, color: iconColor, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  link.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class QuickLinkModel {
  final IconData icon;
  final String label;
  final Color bgColor;
  final GlobalKey? showcaseKey; // ← جديد
  final String? showcaseDescription; // ← جديد

  QuickLinkModel({
    required this.icon,
    required this.label,
    required this.bgColor,
    this.showcaseKey, // ← جديد
    this.showcaseDescription, // ← جديد
  });
}
