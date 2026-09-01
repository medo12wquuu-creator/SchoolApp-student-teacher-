import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

// ثوابت الأشهر باللغة العربية
const List<String> _kArabicMonths = [
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

// أسبوع كامل (7 أيام)
const List<String> _kAllDaysInArabic = [
  'السبت',
  'الأحد',
  'الإثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
];

// أيام الدوام فقط (5 أيام)
const List<String> _kWorkDaysInArabic = [
  'الأحد',
  'الإثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
];

class TeacherHomeDate extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final bool isInteractive;

  /// 🌟 خاصية جديدة: تحديد هل نعرض أيام الدوام فقط (5 أيام) أم الأسبوع كامل (7 أيام)
  final bool showWorkDaysOnly;

  const TeacherHomeDate({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.isInteractive = true,
    this.showWorkDaysOnly = false, // افتراضياً يعرض كل الأيام
  });

  Future<void> _selectDateFromPicker(
    BuildContext context,
    DateTime initialDate,
  ) async {
    if (!isInteractive) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(initialDate.year - 1),
      lastDate: DateTime(initialDate.year + 1),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: '',
      selectableDayPredicate: showWorkDaysOnly
          ? (DateTime date) =>
                date.weekday != DateTime.friday &&
                date.weekday != DateTime.saturday
          : null,
    );

    if (picked != null && onDateSelected != null) {
      onDateSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime baseDate = selectedDate ?? DateTime.now();
    final int currentYear = baseDate.year;
    final String currentMonthName = _kArabicMonths[baseDate.month - 1];

    // تحديد الأيام المراد عرضها وبدايتها
    final List<String> daysToDisplay = showWorkDaysOnly
        ? _kWorkDaysInArabic
        : _kAllDaysInArabic;

    // حساب بداية القائمة (إما السبت للأسبوع الكامل أو الأحد لأيام الدوام)
    final int dayOffset = showWorkDaysOnly
        ? (baseDate.weekday % 7) // يوم الأحد
        : ((baseDate.weekday + 1) % 7); // يوم السبت

    final DateTime startOfWeek = baseDate.subtract(Duration(days: dayOffset));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ktextColor.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: kprimeryColor.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. رأس البطاقة (الشهر والسنة والتقويم)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$currentMonthName $currentYear",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: ktextColor.withOpacity(0.9),
                  letterSpacing: 0.3,
                ),
              ),
              if (isInteractive)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => _selectDateFromPicker(context, baseDate),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: kprimeryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. عرض الأيام
          Directionality(
            textDirection: TextDirection.rtl,
            child: showWorkDaysOnly
                // 🔹 في حالة أيام الدوام (5 أيام): استخدام Row لتقسيم المساحة بالتساوي
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(daysToDisplay.length, (index) {
                      final DateTime itemDate = startOfWeek.add(
                        Duration(days: index),
                      );
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: _buildDayCard(
                            dayName: daysToDisplay[index],
                            itemDate: itemDate,
                            baseDate: baseDate,
                          ),
                        ),
                      );
                    }),
                  )
                // 🔹 في حالة الأسبوع الكامل (7 أيام): استخدام ListView للتمرير الأفقي
                : SizedBox(
                    height: 75,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: daysToDisplay.length,
                      itemBuilder: (context, index) {
                        final DateTime itemDate = startOfWeek.add(
                          Duration(days: index),
                        );
                        return Container(
                          width: 45,
                          margin: const EdgeInsetsDirectional.only(end: 8),
                          child: _buildDayCard(
                            dayName: daysToDisplay[index],
                            itemDate: itemDate,
                            baseDate: baseDate,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ودجت صغيرة لبناء كرت اليوم لتجنب تكرار الكود
  Widget _buildDayCard({
    required String dayName,
    required DateTime itemDate,
    required DateTime baseDate,
  }) {
    final bool isSelected =
        itemDate.year == baseDate.year &&
        itemDate.month == baseDate.month &&
        itemDate.day == baseDate.day;

    return GestureDetector(
      onTap: () {
        if (isInteractive && onDateSelected != null) {
          onDateSelected!(itemDate);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kprimeryColor : kbackgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? kprimeryColor : ktextColor.withOpacity(0.08),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kprimeryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                color: isSelected
                    ? kwhiteColor.withOpacity(0.9)
                    : ktextColor.withOpacity(0.7),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              itemDate.day.toString(),
              style: TextStyle(
                color: isSelected ? kwhiteColor : kprimeryColor,
                fontSize: isSelected ? 17 : 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 2),
              Container(
                height: 4,
                width: 4,
                decoration: const BoxDecoration(
                  color: kseconderyColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
