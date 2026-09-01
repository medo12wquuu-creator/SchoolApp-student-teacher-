 import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/today_schedual_model/today_schedual_model.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/widgets/today_schedual_lesson_container.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/widgets/today_schedual_weekend_view.dart';
 
IconData _subjectIcon(String? subject) {
  if (subject == null) return Icons.book_rounded;
  if (subject.contains('رياضيات') ||
      subject.contains('حساب') ||
      subject.contains('جبر') ||
      subject.contains('هندسة')) {
    return Icons.functions_rounded;
  }
  if (subject.contains('علوم') ||
      subject.contains('فيزياء') ||
      subject.contains('كيمياء') ||
      subject.contains('أحياء')) {
    return Icons.science_rounded;
  }
  if (subject.contains('عربي') ||
      subject.contains('لغة عربية') ||
      subject.contains('قرآن') ||
      subject.contains('إسلامية') ||
      subject.contains('دين')) {
    return Icons.menu_book_rounded;
  }
  if (subject.contains('إنجليزي') ||
      subject.contains('English') ||
      subject.contains('فرنسي') ||
      subject.contains('French')) {
    return Icons.language_rounded;
  }
  if (subject.contains('اجتماعيات') ||
      subject.contains('تاريخ') ||
      subject.contains('جغرافيا') ||
      subject.contains('وطن')) {
    return Icons.public_rounded;
  }
  if (subject.contains('حاسوب') ||
      subject.contains('كمبيوتر') ||
      subject.contains('معلوماتية')) {
    return Icons.computer_rounded;
  }
  if (subject.contains('فن') ||
      subject.contains('رسم') ||
      subject.contains('تصميم')) {
    return Icons.palette_rounded;
  }
  if (subject.contains('رياضة') ||
      subject.contains('بدنية') ||
      subject.contains('تربية بدنية')) {
    return Icons.sports_soccer_rounded;
  }
  return Icons.book_rounded;
}

final Map<String, Color> _sectionColorMap = {};
final List<Color> _appColors = [
  kprimeryColor,
  kadditionalColor,
  kseconderyColor,
  kDarkPrimaryColor,
  kLightRedColor,
];

Color _sectionColor(String? section) {
  if (section == null || section.isEmpty) return kprimeryColor;
  if (!_sectionColorMap.containsKey(section)) {
    _sectionColorMap[section] =
        _appColors[_sectionColorMap.length % _appColors.length];
  }
  return _sectionColorMap[section]!;
}

class TodaySchedual extends StatelessWidget {
  const TodaySchedual({super.key, required this.lessons});

  final List<TodaySchedualModel> lessons;

  @override
  Widget build(BuildContext context) {
    String currentDay = DateFormat('EEEE', 'ar').format(DateTime.now());
    bool isWeekend = currentDay == 'الجمعة' || currentDay == 'السبت';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: kprimeryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'جدول حصص: $currentDay',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ktextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (isWeekend) ...[
          TodaySchedualWeekendView(day: currentDay),
        ] else if (lessons.isEmpty) ...[
          TodaySchedualLessonContainer(
            className: 'لا توجد حصص اليوم',
            subject: 'تحقق لاحقاً',
            time: '--:--',
            icon: Icons.event_note_rounded,
            color: kseconderyColor,
          ),
        ] else ...[
          for (int index = 0; index < lessons.length; index++) ...[
            TodaySchedualLessonContainer(
              className: lessons[index].section?.name ?? 'حصة غير متوفرة',
              subject: lessons[index].subject?.name ?? 'غير متوفر',
              time: lessons[index].timeSlot != null
                  ? '${lessons[index].timeSlot!.startTime ?? ''} - ${lessons[index].timeSlot!.endTime ?? ''}'
                  : 'غير محدد',
              icon: _subjectIcon(lessons[index].subject?.name),
              color: _sectionColor(lessons[index].section?.name),
            ),
            if (index < lessons.length - 1) const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}
