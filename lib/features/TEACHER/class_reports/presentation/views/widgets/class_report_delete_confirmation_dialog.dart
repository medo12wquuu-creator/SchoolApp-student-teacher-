import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/features/TEACHER/class_reports/data/models/class_report_model.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/view_models/delete_report/delete_class_report_cubit.dart';


class ClassReportDeleteConfirmationDialog extends StatelessWidget {
  final ClassReportModel report;

  const ClassReportDeleteConfirmationDialog({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xffFCE8E8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: kRedColor,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'حذف التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ktextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'هل أنت تأكد من رغبتك في حذف هذا التقرير؟ لا يمكن التراجع عن هذا الإجراء.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kRedColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      getIt<DeleteClassReportCubit>().deleteReport(
                        reportId: '${report.id}',
                      );
                    },
                    child: const Text(
                      'تأكيد الحذف',
                      style: TextStyle(
                        color: kwhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(
                        color: ktextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}