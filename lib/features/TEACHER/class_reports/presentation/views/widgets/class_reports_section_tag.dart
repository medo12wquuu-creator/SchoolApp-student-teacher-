
import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class ClassReportsSectionTag extends StatelessWidget {
  final String sectionName;

  const ClassReportsSectionTag({super.key, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: klightPrimeryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          sectionName,
          style: const TextStyle(
            color: kDarkPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}