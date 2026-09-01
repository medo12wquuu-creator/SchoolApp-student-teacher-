import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/class_reports/data/models/class_report_model.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/widgets/class_report_delete_confirmation_dialog.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/widgets/class_report_edit_bottom_sheet.dart';


import 'class_reports_body.dart';

class ClassReportsReportCard extends StatelessWidget {
  final ClassReportModel report;
  final ReportStatus status;

  const ClassReportsReportCard({
    super.key,
    required this.report,
    required this.status,
  });

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final diff = today.difference(date).inDays;
    if (diff == 0) return 'اليوم، $hour:$minute';
    if (diff == 1) return 'أمس، $hour:$minute';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String? _badgeText() {
    if (report.type != null && report.type!.isNotEmpty) {
      return report.type!.contains('عاجل') ? '! عاجل' : report.type;
    }
    if (status == ReportStatus.pending) return '! عاجل';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final badge = _badgeText();
    return Container(
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: status == ReportStatus.pending
            ? const Border(right: BorderSide(color: kseconderyColor, width: 4))
            : const Border(right: BorderSide(color: kadditionalColor, width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    report.isAnonymous ? klightPrimeryColor : Colors.grey[200],
                child: report.isAnonymous
                    ? const Icon(Icons.shield_outlined, color: kprimeryColor)
                    : const Icon(Icons.person, color: ktextColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.studentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: ktextColor,
                      ),
                    ),
                    Text(
                      _formatDate(report.createdAt),
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              if (badge != null) ReportBadgeWidget(badgeText: badge),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            report.title ?? '—',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: ktextColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            report.description ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReportStatusBadge(status: status),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: ktextColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: kwhiteColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (_) => ClassReportEditBottomSheet(report: report),
                    );
                  } else if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          ClassReportDeleteConfirmationDialog(report: report),
                    );
                  }
                },
                itemBuilder: (context) => [
                  if (status == ReportStatus.pending)
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined,
                              size: 18, color: kprimeryColor),
                          SizedBox(width: 8),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: kRedColor),
                        SizedBox(width: 8),
                        Text('حذف', style: TextStyle(color: kRedColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReportBadgeWidget extends StatelessWidget {
  final String badgeText;

  const ReportBadgeWidget({super.key, required this.badgeText});

  @override
  Widget build(BuildContext context) {
    bool isUrgent = badgeText.contains('عاجل');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xffFCE8E8) : klightPrimeryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          color: isUrgent ? kRedColor : kDarkPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

class ReportStatusBadge extends StatelessWidget {
  final ReportStatus status;

  const ReportStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ReportStatus.pending:
        return const Row(
          children: [
            Icon(Icons.circle, size: 10, color: kseconderyColor),
            SizedBox(width: 6),
            Text(
              'الحالة: معلقة',
              style: TextStyle(fontSize: 12, color: ktextColor),
            ),
          ],
        );
      case ReportStatus.reviewed:
        return const Row(
          children: [
            Icon(Icons.check_circle, size: 14, color: kadditionalColor),
            SizedBox(width: 4),
            Text(
              'تمت المراجعة',
              style: TextStyle(
                fontSize: 12,
                color: kadditionalColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
    }
  }
}
