import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class ClassReportsFilterChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ClassReportsFilterChips({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['الكل', 'معلقة', 'تمت المراجعة'];
    return Row(
      children: List.generate(filters.length, (index) {
        final isSelected = selectedIndex == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index == filters.length - 1 ? 0 : 4.0,
              right: index == 0 ? 0 : 4.0,
            ),
            child: InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? kprimeryColor : klightPrimeryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isSelected ? kwhiteColor : kDarkPrimaryColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
