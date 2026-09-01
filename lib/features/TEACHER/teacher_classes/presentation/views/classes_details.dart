import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/classes_details_body.dart';

class ClassesDetails extends StatelessWidget {
  final String sectionId;
  final String semesterId;
  final String? semesterName;
  final String sectionName;

  const ClassesDetails({
    super.key,
    required this.sectionId,
    required this.semesterId,
    this.semesterName,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClassesDetailsBody(
        sectionId: sectionId,
        semesterId: semesterId,
        semesterName: semesterName,
        sectionName: sectionName,
      ),
    );
  }
}
