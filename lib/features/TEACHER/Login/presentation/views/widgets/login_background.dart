// import 'package:flutter/material.dart';
// import 'package:schoole_application/core/constants/colors_constants.dart';
// import 'package:schoole_application/core/constants/images.dart';
// import 'package:schoole_application/core/constants/text_styles.dart';
// import 'package:schoole_application/features/Login/presentation/views/widgets/login_input.dart';

// class LoginBackground extends StatefulWidget {
//   const LoginBackground({super.key});

//   @override
//   State<LoginBackground> createState() => _LoginBackgroundState();
// }

// class _LoginBackgroundState extends State<LoginBackground> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // إزالة التركيز عن أي حقل إدخال حالي وإخفاء الكيبورد
//         FocusScopeNode currentFocus = FocusScope.of(context);
//         if (!currentFocus.hasPrimaryFocus) {
//           currentFocus.unfocus();
//         }
//       },
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: Stack(
//               children: [
//                 Center(
//                   child: Image.asset(
//                     AssetData.KloginBackgroundImage,
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.7),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned.fill(
//                   top: 45,
//                   child: Align(
//                     alignment: Alignment.topCenter,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 65,
//                           width: 65,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             color: kbackgroundColor,
//                           ),
//                           child: Center(
//                             child: Icon(
//                               Icons.school,
//                               size: 35,
//                               color: kprimeryColor,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 12),
//                         Text(
//                           'مدرسة القمة الحديثة ',
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.w900,
//                             color: ktextColor,
//                           ),
//                         ),
//                         SizedBox(height: 3),
//                         Text(
//                           'Al Qimmah School ',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: kseconderyColor,
//                           ),
//                         ),
//                         SizedBox(height: 22),
//                         LoginInput(),
//                         SizedBox(height: 20),
//                         Text(
//                           '22 24  A L  Q I M M A H  S C H O O L',
//                           style: Styles.textStyle15.copyWith(
//                             color: kadditionalColor.withOpacity(0.3),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:schoole_application/core/constants/colors_constants.dart';
// // import 'package:schoole_application/core/constants/images.dart';
// // import 'package:schoole_application/core/constants/text_styles.dart';
// // import 'package:schoole_application/features/Login/presentation/views/widgets/login_input.dart';

// // class LoginBackground extends StatefulWidget {
// //   const LoginBackground({super.key});

// //   @override
// //   State<LoginBackground> createState() => _LoginBackgroundState();
// // }

// // class _LoginBackgroundState extends State<LoginBackground> {
// //   @override
// //   Widget build(BuildContext context) {
// //     // جلب أبعاد الشاشة الحالية لضمان استقرار الـ Stack
// //     final double screenHeight = MediaQuery.of(context).size.height;
// //     final double screenWidth = MediaQuery.of(context).size.width;

// //     return GestureDetector(
// //       onTap: () {
// //         FocusScopeNode currentFocus = FocusScope.of(context);
// //         if (!currentFocus.hasPrimaryFocus) {
// //           currentFocus.unfocus();
// //         }
// //       },
// //       // الـ SizedBox هنا هو الضمان لمنع الـ Layout Crash
// //       child: SizedBox(
// //         height: screenHeight,
// //         width: screenWidth,
// //         child: Stack(
// //           children: [
// //             // 1. طبقة صورة الخلفية
// //             Positioned.fill(
// //               child: Image.asset(
// //                 AssetData.KloginBackgroundImage,
// //                 fit: BoxFit.cover,
// //               ),
// //             ),

// //             // 2. طبقة التدرج اللوني
// //             Positioned.fill(
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     begin: Alignment.topCenter,
// //                     end: Alignment.bottomCenter,
// //                     colors: [
// //                       Colors.transparent,
// //                       Colors.black.withOpacity(0.7),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),

// //             // 3. طبقة المحتوى القابلة للتمرير
// //             Positioned.fill(
// //               child: SafeArea(
// //                 child: SingleChildScrollView(
// //                   physics: const BouncingScrollPhysics(),
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 20),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         const SizedBox(height: 45),

// //                         // أيقونة المدرسة
// //                         Container(
// //                           height: 65,
// //                           width: 65,
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(20),
// //                             color: kbackgroundColor,
// //                           ),
// //                           child: const Center(
// //                             child: Icon(
// //                               Icons.school,
// //                               size: 35,
// //                               color: kprimeryColor,
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 12),

// //                         // اسم المدرسة عربي
// //                         Text(
// //                           'مدرسة القمة الحديثة ',
// //                           style: TextStyle(
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.w900,
// //                             color: ktextColor,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 3),

// //                         // اسم المدرسة إنجليزي
// //                         Text(
// //                           'Al Qimmah School ',
// //                           style: TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.w700,
// //                             color: kseconderyColor,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 22),

// //                         // حقول الإدخال والـ Sign In button
// //                         const LoginInput(),
// //                         const SizedBox(height: 30),

// //                         // الفوتر الأسفل
// //                         Text(
// //                           '22 24  A L  Q I M M A H  S C H O O L',
// //                           style: Styles.textStyle15.copyWith(
// //                             color: kadditionalColor.withOpacity(0.3),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 20),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
