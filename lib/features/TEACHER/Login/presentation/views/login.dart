// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:schooly/features/TEACHER/Login/presentation/view_models/login_cubit/login_cubit.dart';

// class Login extends StatelessWidget {
//   const Login({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<LoginCubit, LoginState>(
//       listener: (context, state) async {
//         if (state is LoginSuccess) {
//           final token = state.loginModel.token;

//           if (token == null || token.isEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('No token returned from server')),
//             );
//             return;
//           }

//           final userCubit = context.read<UserCubit>();
//           final loginUser = state.loginModel.user;
//           final fallbackUser = UserModel(
//             id: loginUser?.id ?? 0,
//             firstName: loginUser?.email?.split('@').first ?? 'Teacher',
//             email: loginUser?.email ?? '',
//             phone: loginUser?.phoneNumber,
//             role: (loginUser?.roleId == 3) ? 'teacher' : 'student',
//           );

//           await userCubit.saveSession(token: token, user: fallbackUser);

//           // لا تنتظر الشبكة قبل الانتقال — حدّث البيانات في الخلفية
//           unawaited(userCubit.refreshUserFromServer());

//           if (!context.mounted) return;

//           if (state.loginModel.message != null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.loginModel.message!),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           }

//           final roleId = loginUser?.roleId;

//           if (roleId == 3) {
//             Get.offAll(() => const TeacherHome());
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('تطبيق المعلم فقط حالياً')),
//             );
//           }
//         } else if (state is LoginFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.errMassage),
//               backgroundColor: Colors.red,
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         return const Scaffold(body: LoginBody());
//       },
//     );
//   }
// }
