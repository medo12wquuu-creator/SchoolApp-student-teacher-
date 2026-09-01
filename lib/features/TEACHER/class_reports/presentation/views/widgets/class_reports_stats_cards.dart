import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/class_reports/data/models/class_report_model.dart';
import 'class_reports_body.dart';

class ClassReportsStatsCards extends StatelessWidget {
  final List<ClassReportModel> reports;
  final ReportStatus Function(String?) mapStatus;

  const ClassReportsStatsCards({
    super.key,
    required this.reports,
    required this.mapStatus,
  });

  @override
  Widget build(BuildContext context) {
    int totalCount = reports.length;
    int pendingCount = reports
        .where((r) => mapStatus(r.status) == ReportStatus.pending)
        .length;
    int reviewedCount = reports
        .where((r) => mapStatus(r.status) == ReportStatus.reviewed)
        .length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: klightPrimeryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _StatItem(
            count: '$totalCount',
            label: 'الإجمالي',
            textColor: kDarkPrimaryColor,
            bgColor: kwhiteColor,
          ),
          const SizedBox(width: 8),
          _StatItem(
            count: '$pendingCount',
            label: 'معلقة',
            textColor: kRedColor,
            bgColor: const Color(0xffFCE8E8),
          ),
          const SizedBox(width: 8),
          _StatItem(
            count: '$reviewedCount',
            label: 'تمت المراجعة',
            textColor: kadditionalColor,
            bgColor: klightSecoderyColor,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final Color textColor;
  final Color bgColor;

  const _StatItem({
    required this.count,
    required this.label,
    required this.textColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: textColor.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
