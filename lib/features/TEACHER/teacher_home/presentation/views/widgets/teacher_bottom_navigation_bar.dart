import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/images.dart';
 
class TeacherBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TeacherBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff4A90E2);

    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 12),
      height: 65, // ارتفاع رشيق ومناسب جداً بدون نصوص
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: primaryColor.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.06), width: 1),
      ),
      child: Theme(
        // هذا الجزء السحري لإلغاء أي تأثيرات أو هوامش افتراضية للـ NavigationBar
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          // حل مشكلة الـ Overflow: ضبط المسافات بين الأيقونات
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: [
            _buildNavItem(AssetData.khomeIcon, currentIndex == 0),
            _buildNavItem(AssetData.kclassesIcon, currentIndex == 1),
            _buildNavItem(AssetData.kchatIcon, currentIndex == 2),
            _buildNavItem(AssetData.kschedualIcon, currentIndex == 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, bool isSelected) {
    const Color primaryColor = Color(0xff4A90E2);

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(1), // تقليل الحشو قليلاً ليناسب الارتفاع
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, primaryColor.withOpacity(0.75)],
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ImageIcon(
          AssetImage(iconPath),
          size: 44, // حجم متناسق لا يسبب overflow
          color: isSelected ? Colors.white : ktextColor,
        ),
      ),
      label: '',
    );
  }
}
