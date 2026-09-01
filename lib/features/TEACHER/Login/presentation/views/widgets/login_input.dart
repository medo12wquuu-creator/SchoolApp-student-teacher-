// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:schoole_application/core/constants/colors_constants.dart';
// import 'package:schoole_application/core/constants/text_styles.dart';
// import 'package:schoole_application/features/Login/presentation/view_models/login_cubit/login_cubit.dart';
// import 'package:schoole_application/features/Login/presentation/views/widgets/login_input_textfield.dart';

// class LoginInput extends StatefulWidget {
//   const LoginInput({super.key});

//   @override
//   State<LoginInput> createState() => _LoginInputState();
// }

// class _LoginInputState extends State<LoginInput> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   String? _emailError;
//   String? _passwordError;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       decoration: BoxDecoration(
//         color: kbackgroundColor,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white.withOpacity(0.25),
//             spreadRadius: 8,
//             blurRadius: 15,
//             offset: const Offset(0, 0),
//           ),
//         ],
//       ),
//       width: MediaQuery.of(context).size.width * .85,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Welcome Back ',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w900,
//               color: ktextColor,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Enter your information to reach your account ',
//             style: Styles.textStyle15.copyWith(
//               fontWeight: FontWeight.w400,
//               color: ktextColor,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'EMAIL ADDRESS :',
//             style: Styles.textStyle15.copyWith(
//               color: kprimeryColor.withOpacity(0.8),
//             ),
//           ),
//           const SizedBox(height: 6),
//           LoginInputItem(
//             hintText: 'example@gmail.com',
//             prefixIcon: Icons.email_outlined,
//             controller: _emailController,
//             errorText: _emailError,
//           ),
//           const SizedBox(height: 5),
//           Text(
//             'PASSWORD :',
//             style: Styles.textStyle15.copyWith(
//               color: kprimeryColor.withOpacity(0.8),
//             ),
//           ),
//           const SizedBox(height: 6),
//           LoginInputItem(
//             hintText: 'example1234',
//             prefixIcon: Icons.lock,
//             isPassword: true,
//             controller: _passwordController,
//             errorText: _passwordError,
//           ),
//           Text(
//             'Forget Password ?',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//               color: ktextColor.withOpacity(0.9),
//             ),
//           ),
//           const SizedBox(height: 25),
//           BlocConsumer<LoginCubit, LoginState>(
//             listener: (context, state) {
//               if (state is LoginFailure) {
//                 // ✅ التصحيح السحري: تعديل اسم الحقل ليطابق الـ Cubit والـ Failure تماماً
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       state.errMassage,
//                     ), // تعديل الحرف إلى a ليصبح errMassage
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             builder: (context, state) {
//               final isLoading = state is LoginLoading;

//               return TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: isLoading
//                       ? kprimeryColor.withOpacity(0.2)
//                       : kprimeryColor.withOpacity(0.4),
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                 ),
//                 onPressed: () {
//                   if (isLoading) return;

//                   setState(() {
//                     _emailError = _emailController.text.isEmpty
//                         ? "Please enter your email"
//                         : null;
//                     _passwordError = _passwordController.text.isEmpty
//                         ? "Please enter your password"
//                         : null;
//                   });

//                   if (_emailError != null || _passwordError != null) {
//                     return;
//                   }

//                   final loginCubit = BlocProvider.of<LoginCubit>(context);
//                   loginCubit.setEmail(_emailController.text);
//                   loginCubit.setPassword(_passwordController.text);
//                   loginCubit.sendLoginDetails();
//                 },
//                 child: Center(
//                   child: isLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : Text(
//                           'SIGN IN',
//                           style: Styles.textStyle15.copyWith(color: ktextColor),
//                         ),
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'New to School?  ',
//                 style: Styles.textStyle15.copyWith(
//                   fontWeight: FontWeight.w400,
//                   color: ktextColor,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {},
//                 child: Text(
//                   'CREAT ACCOUNT',
//                   style: Styles.textStyle15.copyWith(color: kprimeryColor),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }
