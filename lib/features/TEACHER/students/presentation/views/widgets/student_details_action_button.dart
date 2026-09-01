import 'package:flutter/material.dart';

class StudentDetailsActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color primaryColor;
  final Color bgColor;
  final VoidCallback onTap;

  // ألوان افتراضية في حال لم تكن معرفة عالمياً في مشروعك
  final Color? textColor;
  final Color? surfaceColor;

  const StudentDetailsActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.primaryColor,
    required this.bgColor,
    required this.onTap,
    this.textColor,
    this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام ألوان مخصصة أو استخدام الافتراضية للمشروع
    final finalTextColor =
        textColor ?? const Color(0xFF2D2D2D); // بديل لـ ktextColor
    final finalSurfaceColor =
        surfaceColor ?? Colors.white; // بديل لـ kwhiteColor

    return Container(
      decoration: BoxDecoration(
        color: finalSurfaceColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            // تم استخدام Ink هنا لضمان ظهور تأثير الضغط فوق الحدود والخلفية
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: primaryColor.withOpacity(0.12),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize
                  .min, // ليأخذ الزر حجم محتواه فقط أو يتمدد حسب الحاجة
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // حاوية الأيقونة الدائرية
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: primaryColor, size: 18),
                ),
                const SizedBox(width: 10),
                // النص مع إمكانية التكيف لمنع الأخطاء
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: finalTextColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow
                        .ellipsis, // يضع نقاط ... إذا كان النص طويلاً جداً
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
