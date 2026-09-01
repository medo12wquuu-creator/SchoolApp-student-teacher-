import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 211, 228, 247),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: ' رئيسية',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                label: 'برنامج الأسبوع',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.chat_outlined,
                label: 'محادثة',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                label: 'ملفي الشخصي',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: isActive ? 40 : 20,
            height: isActive ? 34 : 20,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFE3F2FD) : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF1E88E5).withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: isActive ? 26 : 22,
              color: isActive
                  ? const Color(0xFF1E88E5)
                  : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive
                  ? const Color(0xFF1E88E5)
                  : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
