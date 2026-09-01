import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
 
class QuizzesStatusTabs extends StatelessWidget {
  final TabController controller;
  final int allCount;
  final int draftCount;
  final int closedCount;
  final int publishedCount;
  final ValueChanged<int> onTap;

  const QuizzesStatusTabs({
    super.key,
    required this.controller,
    required this.allCount,
    required this.draftCount,
    required this.closedCount,
    required this.publishedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: false,
        indicator: BoxDecoration(
          color: kprimeryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: kprimeryColor.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: kwhiteColor,
        unselectedLabelColor: Colors.grey.shade700,
        labelPadding: EdgeInsets.zero,
        onTap: onTap,
        tabs: [
          _buildTabItem('الكل', allCount, 0),
          _buildTabItem('معلقة ⏳', draftCount, 1),
          _buildTabItem('مغلقة 🔒', closedCount, 2),
          _buildTabItem('مرسلة 🚀', publishedCount, 3),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int count, int index) {
    final isSelected = controller.index == index;
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.25)
                  : Colors.black.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? kwhiteColor : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}