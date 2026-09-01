import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class StudentDetailsSectionHeader extends StatelessWidget {
  final String title;
  final bool hasViewAll;
  final bool isWarningTitle;
  final VoidCallback? onViewAllTap; // أكشن عند الضغط على عرض الكل

  const StudentDetailsSectionHeader({
    super.key,
    required this.title,
    this.hasViewAll = false,
    this.isWarningTitle = false,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // عنوان القسم مع الخط العمودي الجانبي
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: isWarningTitle ? kLightRedColor : kprimeryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: ktextColor,
              ),
            ),
          ],
        ),

        // زر عرض الكل (يظهر فقط إذا كان true)
        if (hasViewAll)
          GestureDetector(
            onTap: onViewAllTap,
            child: Row(
              children: [
                Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontSize: 13,
                    color: kDarkPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                // تم تعديل اتجاه السهم ليناسب الواجهات العربية بشكل أفضل
                Icon(
                  Icons.arrow_forward_ios,
                  size: 11,
                  color: kDarkPrimaryColor,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
