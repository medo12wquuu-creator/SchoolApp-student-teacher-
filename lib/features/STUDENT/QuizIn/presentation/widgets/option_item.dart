import 'package:flutter/material.dart';

class OptionItem extends StatelessWidget {
  final String body;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionItem({
    super.key,
    required this.body,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1E88E5)
                : const Color(0xFFE1E5EA),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF1E88E5) : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                body,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFF1E88E5)
                      : const Color(0xFF172033),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
