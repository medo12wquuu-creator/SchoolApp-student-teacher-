import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/student_details_action_button.dart';

// تأكد من استيراد ملف الألوان الخاص بك هنا
// import 'package:schoole_application/core/constants/colors_constants.dart';

class StudentDetailsQuickActions extends StatelessWidget {
  final VoidCallback onAddNoteTap;
  final VoidCallback onAddReportTap;

  const StudentDetailsQuickActions({
    super.key,
    required this.onAddNoteTap,
    required this.onAddReportTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // زر إضافة ملاحظة (أخضر تفاعلي)
        Expanded(
          child: StudentDetailsActionButton(
            label: 'إضافة ملاحظة',
            icon: Icons.bookmark_add_rounded,
            primaryColor: kadditionalColor,
            bgColor: klightAdditionalColor,
            onTap: onAddNoteTap,
          ),
        ),
        const SizedBox(width: 14),
        // زر إضافة تقرير (أزرق تفاعلي)
        Expanded(
          child: StudentDetailsActionButton(
            label: 'إضافة تقرير',
            icon: Icons.analytics_rounded,
            primaryColor: kprimeryColor,
            bgColor: klightPrimeryColor,
            onTap: onAddReportTap,
          ),
        ),
      ],
    );
  }
}
