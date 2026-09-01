import 'package:flutter/material.dart';
import 'dart:math';

import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/performence_card_bar_with_count.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/performence_card_state.dart';


class ClassesDetailsPerformanceCard extends StatelessWidget {
  // معدلات الطلاب (0-100) — تُحسب فقط عند اكتمال العلامات
  final List<double> grades;
  // اسم الفصل الدراسي الحقيقي القادم من الباك (/teacherSections)
  final String? semesterName;
  // 🆕 صحيح عندما لم تكتمل العلامات الأربعة → نعرض رسالة انتظار بدل المخطط
  final bool showWaiting;

  const ClassesDetailsPerformanceCard({
    super.key,
    required this.grades,
    this.semesterName,
    this.showWaiting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: showWaiting ? _buildWaitingContent() : _buildChartContent(),
    );
  }

  // 🆕 رأس البطاقة الموحّد
  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.analytics_outlined, color: kprimeryColor),
        const SizedBox(width: 8),
        const Text(
          'أداء الفصل',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  // 🆕 رسالة الانتظار عند عدم اكتمال العلامات الأربعة
  Widget _buildWaitingContent() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kseconderyColor.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                size: 42,
                color: kseconderyColor,
              ),
              const SizedBox(height: 10),
              const Text(
                'الرجاء الانتظار لاكمال العلامات',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF8A6D3B),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 30, color: ktextColor.withOpacity(0.4)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildSemesterBadge()],
        ),
      ],
    );
  }

  // 🆕 مخطط الأداء (يُعرض فقط عند اكتمال العلامات)
  Widget _buildChartContent() {
    final bool hasData = grades.isNotEmpty;

    // 1. تقسيم المعدلات إلى 5 فئات
    List<int> bins = [0, 0, 0, 0, 0];
    double sum = 0;

    for (double grade in grades) {
      sum += grade;

      if (grade <= 20) {
        bins[0]++;
      } else if (grade <= 40) {
        bins[1]++;
      } else if (grade <= 60) {
        bins[2]++;
      } else if (grade <= 80) {
        bins[3]++;
      } else {
        bins[4]++;
      }
    }

    // 2. حساب المتوسط العام للفصل
    double average = hasData ? sum / grades.length : 0;
    String avgLetter = hasData ? _getLetterGrade(average) : '—';
    String avgLabel = hasData ? _getGradeLabel(avgLetter) : 'لا توجد درجات';

    // 3. إيجاد أعلى تكرار لضبط ارتفاع الأعمدة
    final int maxCount = bins.reduce(max) > 0 ? bins.reduce(max) : 1;

    // 4. تحديد حالة الفصل
    final int goodGradesCount = bins[3] + bins[4];
    final int badGradesCount = bins[0] + bins[1];
    final bool isClassGood = goodGradesCount >= badGradesCount;

    final List<Color> binColors = [
      kRedColor, // ضعيف جداً
      kLightRedColor, // ضعيف
      kseconderyColor, // مقبول
      kadditionalColor.withOpacity(0.5), // جيد
      kadditionalColor, // ممتاز
    ];

    // 🆕 تسميات الأعمدة حسب الفئة
    const binLabels = ['ضعيف جداً', 'ضعيف', 'مقبول', 'جيد', 'ممتاز'];

    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 20),

        // الأعمدة مع الأرقام فوقها والتسمية تحتها
        SizedBox(
          height: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(5, (index) {
              double height = (bins[index] / maxCount) * 80;
              return PerformenceCardBarWithCount(
                height,
                binColors[index],
                bins[index],
                label: binLabels[index],
              );
            }),
          ),
        ),

        const SizedBox(height: 15),

        Text(
          !hasData
              ? 'لا توجد درجات بعد لعرض توزيع الأداء'
              : isClassGood
              ? 'المستوى العام للفصل ممتاز'
              : 'الفصل بحاجة إلى متابعة دراسية',
          style: TextStyle(
            color: !hasData
                ? ktextColor
                : isClassGood
                ? kadditionalColor
                : kRedColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        Divider(height: 30, color: ktextColor.withOpacity(0.4)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 🆕 بطاقة الفصل الدراسي بتصميم مميز (بدل الحضور القديم)
            _buildSemesterBadge(),
            // تمرير المتغيرات المحسوبة ديناميكياً هنا
            PerformenceCardState(
              title: 'المتوسط',
              val: avgLetter,
              label: avgLabel,
              isCircle: false,
            ),
          ],
        ),
      ],
    );
  }

  // 🆕 شارة الفصل الدراسي المميزة
  Widget _buildSemesterBadge() {
    return Column(
      children: [
        Text(
          'الفصل',
          style: TextStyle(
            color: ktextColor.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kprimeryColor, kDarkPrimaryColor],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: kprimeryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.school_rounded,
                size: 16,
                color: kwhiteColor,
              ),
              const SizedBox(width: 6),
              Text(
                _semesterLabel(semesterName),
                style: const TextStyle(
                  color: kwhiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // دالة لتحويل اسم الفصل إلى صيغة "الفصل الدراسي الأول / الثاني ..."
  String _semesterLabel(String? name) {
    if (name == null || name.trim().isEmpty) return 'الفصل الدراسي';
    final n = name.trim();
    // لو الاسم مكتمل بالفعل (مثل: الفصل الدراسي الثاني) نحافظ عليه
    if (n.startsWith('الفصل الدراسي')) return n;
    const ordinals = ['الأول', 'الثاني', 'الثالث', 'الرابع'];
    for (final o in ordinals) {
      if (n.contains(o)) return 'الفصل الدراسي $o';
    }
    // لو في رقم صريح مثل "الفصل 2"
    final match = RegExp(r'(\d+)').firstMatch(n);
    if (match != null) {
      const arabic = ['', 'الأول', 'الثاني', 'الثالث', 'الرابع'];
      final num = int.parse(match.group(1)!);
      if (num >= 1 && num <= 4) return 'الفصل الدراسي ${arabic[num]}';
      return 'الفصل الدراسي $num';
    }
    return 'الفصل الدراسي';
  }

  // دالة لتحويل المعدل الرقمي إلى حرف (A, B, C...)
  String _getLetterGrade(double avg) {
    if (avg >= 90) return 'A';
    if (avg >= 80) return 'B+';
    if (avg >= 70) return 'B';
    if (avg >= 60) return 'C+';
    if (avg >= 50) return 'C';
    return 'F';
  }

  // دالة للحصول على التقييم النصي بناءً على الحرف
  String _getGradeLabel(String letter) {
    switch (letter) {
      case 'A':
        return 'ممتاز';
      case 'B+':
        return 'جيد جداً';
      case 'B':
        return 'جيد';
      case 'C+':
        return 'مقبول';
      case 'C':
        return 'ضعيف';
      default:
        return 'رسوب';
    }
  }
}
