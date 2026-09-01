// import 'package:flutter/material.dart';

// class QuickActionsButton extends StatelessWidget {
//   BuildContext context;
//   IconData icon;
//   String text;
//   Color backgroundColor;
//   Color foregroundColor;
//   final VoidCallback onPressed;
//   QuickActionsButton({
//     super.key,
//     required this.context,
//     required this.icon,
//     required this.text,
//     required this.backgroundColor,
//     required this.foregroundColor,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: backgroundColor,
//         foregroundColor: foregroundColor,
//         elevation: 1, // ظل خفيف جداً لعمق ناعم
//         shadowColor: backgroundColor.withOpacity(0.35),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(
//             14,
//           ), // حواف ناعمة عصرية
//           side: BorderSide(
//             color: foregroundColor.withOpacity(0.25), // إطار خفيف جداً
//             width: 1,
//           ),
//         ),
//       ),
//       icon: Icon(icon, size: 18),
//       label: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 0.2,
//         ),
//       ),
//       onPressed: onPressed,
//     );
//   }
// }
import 'package:flutter/material.dart';

class QuickActionsButton extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  const QuickActionsButton({
    super.key,
    required this.context,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
      ),
      onPressed: onPressed,
    );
  }
}
