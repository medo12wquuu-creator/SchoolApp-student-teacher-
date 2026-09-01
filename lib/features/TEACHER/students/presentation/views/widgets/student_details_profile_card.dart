import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class StudentDetailsProfileCard extends StatelessWidget {
  final String studentName;
  final String studentPhoto;
  final String sectionName;

  const StudentDetailsProfileCard({
    super.key,
    required this.studentName,
    required this.studentPhoto,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    // حساب الـ Padding العلوي بشكل ديناميكي لتجنب منطقة الـ Notch في الهواتف الحديثة
    final double topPadding = MediaQuery.of(context).padding.top + 45;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [klightPrimeryColor, kwhiteColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: kprimeryColor.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // إطار الصورة المتألق بهوية التطبيق
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: kwhiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kprimeryColor.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 52,
              backgroundColor: klightPrimeryColor,
              child: ClipOval(
                child: Image.network(
                  studentPhoto,
                  width: 104,
                  height: 104,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person, size: 52, color: kprimeryColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // اسم الطالب
          Text(
            studentName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ktextColor,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          // بادج الصف والشعبة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: kwhiteColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: kprimeryColor.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: kprimeryColor.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              sectionName,
              style: TextStyle(
                fontSize: 13,
                color: kDarkPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
