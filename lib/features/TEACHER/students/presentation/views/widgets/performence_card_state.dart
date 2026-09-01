import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class PerformenceCardState extends StatelessWidget {
  final String title;
  final String val;
  final String label;
  final bool isCircle;
  const PerformenceCardState({
    super.key,
    required this.title,
    required this.val,
    required this.label,
    required this.isCircle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: ktextColor.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(width: 10),
        isCircle
            ? Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: 0.85,
                      strokeWidth: 3,
                      color: kprimeryColor,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  Text(
                    val,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: kseconderyColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  val,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
      ],
    );
  }
}
