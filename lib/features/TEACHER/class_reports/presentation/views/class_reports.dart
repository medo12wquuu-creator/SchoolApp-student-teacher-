import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/widgets/class_reports_body.dart';

class ClassReports extends StatelessWidget {
  final String sectionName;
  final String sectionId;
  final String semesterId;

  const ClassReports({
    super.key,
    this.sectionName = '',
    this.sectionId = '',
    this.semesterId = '',
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClassReportsBody(
        sectionName: sectionName,
        sectionId: sectionId,
        semesterId: semesterId,
      ),
    );
  }
}
