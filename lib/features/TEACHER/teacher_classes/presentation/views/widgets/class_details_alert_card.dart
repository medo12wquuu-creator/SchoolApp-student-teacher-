
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/class_reports.dart';


class ClassDetailsAlertCard extends StatelessWidget {
  final String sectionName;
  final String sectionId;
  final String semesterId;

  const ClassDetailsAlertCard({
    super.key,
    this.sectionName = '',
    this.sectionId = '',
    this.semesterId = '',
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(
            () => ClassReports(
              sectionName: sectionName,
              sectionId: sectionId,
              semesterId: semesterId,
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kLightRedColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kLightRedColor.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kRedColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: kRedColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الشكاوى والتقارير الحالية',
                      style: TextStyle(
                        color: kRedColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'اضغط للتحقق الآن.',
                      style: TextStyle(
                        color: ktextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: kRedColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
