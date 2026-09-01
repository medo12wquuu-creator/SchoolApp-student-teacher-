 
import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
 
class TodaySchedualWeekendView extends StatelessWidget {
  final String day;
  const TodaySchedualWeekendView({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kwhiteColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: ktextColor.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: kprimeryColor.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kprimeryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_available_rounded,
                size: 36,
                color: kprimeryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'استمتع بإجازة يوم $day!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ktextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'نراك غداً بكل نشاط',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ktextColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
