import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/class_reports/data/models/class_report_model.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/widgets/class_reports_report_card.dart';

import 'class_reports_body.dart';

class ClassReportsReportsList extends StatelessWidget {
  final List<ClassReportModel> reports;
  final List<ClassReportModel> filteredReports;
  final ReportStatus Function(String?) mapStatus;

  const ClassReportsReportsList({
    super.key,
    required this.reports,
    required this.filteredReports,
    required this.mapStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          'لا توجد تقارير لهذه الشعبة حالياً',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (filteredReports.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          'لا توجد تقارير مطابقة للتصنيف الحالي',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredReports.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return ClassReportsReportCard(
          report: filteredReports[index],
          status: mapStatus(filteredReports[index].status),
        );
      },
    );
  }
}