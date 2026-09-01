import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/class_students_body.dart';

class ClassStudents extends StatelessWidget {
  final String sectionId;
  final String semesterId;
  final String? semesterName;
  final String sectionName;

  const ClassStudents({
    super.key,
    required this.sectionId,
    required this.semesterId,
    this.semesterName,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClassStudentsBody(
        sectionId: sectionId,
        semesterId: semesterId,
        semesterName: semesterName,
        sectionName: sectionName,
      ),
    );
  }
}
