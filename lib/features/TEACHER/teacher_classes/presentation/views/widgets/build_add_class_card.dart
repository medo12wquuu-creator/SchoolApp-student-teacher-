// import 'package:flutter/material.dart';
// import 'package:schoole_application/core/constants/colors_constants.dart';

// class ClassHeader extends StatelessWidget {
//   final String teacherName;
//   final int remainingClasses;

//   const ClassHeader({
//     super.key,
//     required this.teacherName,
//     required this.remainingClasses,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'مرحباً بك، أستاذ $teacherName',
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: ktextColor,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           'لديك $remainingClasses حصص متبقية اليوم.',
//           style: TextStyle(fontSize: 14, color: ktextColor.withOpacity(0.7)),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:schoole_application/core/constants/colors_constants.dart';

// class ClassHeader extends StatelessWidget {
//   final String teacherName;
//   final int remainingClasses;

//   const ClassHeader({
//     super.key,
//     required this.teacherName,
//     required this.remainingClasses,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           colors: [
//             kprimeryColor,
//             kDarkPrimaryColor,
//           ],
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: kprimeryColor.withOpacity(0.25),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'مرحباً بك، أستاذ $teacherName 👋',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: kwhiteColor,
//                     height: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   'لديك $remainingClasses حصص متبقية اليوم.',
//                   style: TextStyle(
//                     fontSize: 13.5,
//                     color: kwhiteColor.withOpacity(0.85),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: kwhiteColor.withOpacity(0.15),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.class_outlined,
//               color: kwhiteColor,
//               size: 26,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
