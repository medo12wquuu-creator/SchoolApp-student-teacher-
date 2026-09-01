import 'package:flutter/material.dart';

class SemesterButton extends StatelessWidget {
  final String text;
  final List<Color> gradient;
  final Color textColor;
  final bool isPrimary;
  final bool isSelected;
  final VoidCallback? onTap;

  const SemesterButton({
    super.key,
    required this.text,
    required this.gradient,
    required this.textColor,
    this.isPrimary = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // نفس آلية gradient_button.dart: المضغوط 62 والغير مضغوط 50
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: isSelected ? 62 : 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isPrimary ? const Color(0xFF1E88E5) : Colors.black)
                .withOpacity(isSelected ? 0.20 : 0.1),
            blurRadius: isSelected ? 14 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: isSelected ? 18 : 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
