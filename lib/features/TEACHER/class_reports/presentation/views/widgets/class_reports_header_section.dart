import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class ClassReportsHeaderSection extends StatelessWidget {
  const ClassReportsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: ktextColor),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          'التقارير والشكاوى',
          style: TextStyle(
            color: ktextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        // تم تفريغ المساحة لمنع إزاحة العنوان وإبقاء زر الرجوع متناسقاً
        const SizedBox(width: 48),
      ],
    );
  }
}
