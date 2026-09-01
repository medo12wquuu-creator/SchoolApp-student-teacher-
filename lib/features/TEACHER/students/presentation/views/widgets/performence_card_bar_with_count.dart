import 'package:flutter/material.dart';

class PerformenceCardBarWithCount extends StatelessWidget {
  final double? h;
  final Color? c;
  final int? count;
  final String? label;
  const PerformenceCardBarWithCount(
    this.h,
    this.c,
    this.count, {
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: count! > 0 ? Colors.grey[800] : Colors.transparent,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 35,
          height: h! < 5 ? 5 : h,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 6),
          Text(
            label!,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: c,
              height: 1.2,
            ),
            maxLines: 1,
          ),
        ],
      ],
    );
  }
}