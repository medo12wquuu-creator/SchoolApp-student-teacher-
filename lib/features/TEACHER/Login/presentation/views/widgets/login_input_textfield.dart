// import 'package:flutter/material.dart';
// import 'package:schoole_application/core/constants/colors_constants.dart';

// class LoginInputItem extends StatefulWidget {
//   final String hintText;
//   final IconData prefixIcon;
//   final TextInputType keyboardType;
//   final bool isPassword;
//   final TextEditingController? controller;
//   final String? errorText;

//   const LoginInputItem({
//     super.key,
//     required this.hintText,
//     required this.prefixIcon,
//     this.keyboardType = TextInputType.text,
//     this.isPassword = false,
//     this.controller,
//     this.errorText,
//   });

//   @override
//   State<LoginInputItem> createState() => _LoginInputItemState();
// }

// class _LoginInputItemState extends State<LoginInputItem> {
//   late bool obscureText;

//   @override
//   void initState() {
//     super.initState();
//     obscureText = widget.isPassword;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       cursorColor: kprimeryColor.withOpacity(0.4),
//       keyboardType: widget.isPassword
//           ? TextInputType.visiblePassword
//           : widget.keyboardType,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
//         errorText: widget.errorText,
//         helperText: ' ',

//         // تخصيص شكل الحقل عند وجود خطأ (اختياري)
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: Colors.red.withOpacity(0.5),
//             width: 1.5,
//           ),
//         ),

//         prefixIcon: Icon(widget.prefixIcon, color: ktextColor),

//         // إضافة أيقونة العين في النهاية (Suffix Icon) فقط إذا كان الحقل باسوورد
//         suffixIcon: widget.isPassword
//             ? IconButton(
//                 icon: Icon(
//                   obscureText ? Icons.visibility_off : Icons.visibility,
//                   color: kseconderyColor.withOpacity(0.6),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     obscureText = !obscureText;
//                   });
//                 },
//               )
//             : null,

//         filled: true,
//         fillColor: Colors.white.withOpacity(0.05),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: ktextColor.withOpacity(0.3)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: kprimeryColor.withOpacity(0.4),
//             width: 2,
//           ),
//         ),
//       ),
//     );
//   }
// }
