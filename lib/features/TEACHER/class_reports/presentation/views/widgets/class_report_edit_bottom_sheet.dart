import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/features/TEACHER/class_reports/data/models/class_report_model.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/view_models/class_reports/class_reports_cubit.dart';


class ClassReportEditBottomSheet extends StatefulWidget {
  final ClassReportModel report;

  const ClassReportEditBottomSheet({super.key, required this.report});

  @override
  State<ClassReportEditBottomSheet> createState() => _ClassReportEditBottomSheetState();
}

class _ClassReportEditBottomSheetState extends State<ClassReportEditBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.report.title ?? '');
    _descController =
        TextEditingController(text: widget.report.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 20,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'تعديل التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ktextColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'عنوان التقرير',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'تفاصيل التقرير',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimeryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      getIt<ClassReportsCubit>().modifyReport(
                        reportId: '${widget.report.id}',
                        title: _titleController.text,
                        description: _descController.text,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'حفظ التعديلات',
                      style: TextStyle(color: kwhiteColor),
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
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(color: ktextColor),
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