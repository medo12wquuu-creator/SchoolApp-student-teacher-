import 'package:flutter/material.dart';
 import 'package:schooly/core/constants/colors.constants.dart';

class HomeSectionsCard extends StatelessWidget {
  const HomeSectionsCard({super.key, required this.sectionsCount});

  final int sectionsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ktextColor.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: kseconderyColor.withOpacity(0.14),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kseconderyColor.withOpacity(0.3),
                  klightSecoderyColor,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: kDarkPrimaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'شعبك',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: ktextColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$sectionsCount',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: ktextColor,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'إجمالي الشعب',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: ktextColor.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}