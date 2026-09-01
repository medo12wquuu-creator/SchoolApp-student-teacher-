// import 'package:flutter/material.dart';

// class PasswordField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;
//   final bool visible;
//   final VoidCallback onToggle;

//   const PasswordField({
//     super.key,
//     required this.label,
//     required this.controller,
//     required this.visible,
//     required this.onToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       obscureText: !visible,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(
//             visible ? Icons.visibility : Icons.visibility_off,
//           ),
//           onPressed: onToggle,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool visible;
  final VoidCallback onToggle;

  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.visible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
