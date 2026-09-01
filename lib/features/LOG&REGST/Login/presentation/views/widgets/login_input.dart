import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as getx; // استيراد Get للتنقل السلس والآمن

import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/text_styless.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/views/widgets/login_input_textfield.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/views/register1.dart';

class LoginInput extends StatefulWidget {
  const LoginInput({super.key});

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: kbackgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.25),
            spreadRadius: 8,
            blurRadius: 15,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width * .85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'مرحبا بك',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: ktextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ': أدخل معلوماتك للدخول إلى حسابك ',
            style: Styles.textStyle15.copyWith(
              fontWeight: FontWeight.w400,
              color: ktextColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            ':البريد الاكتروني',
            style: Styles.textStyle15.copyWith(
              color: kprimeryColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 6),
          LoginInputItem(
            hintText: 'example@gmail.com',
            prefixIcon: Icons.email_outlined,
            controller: _emailController,
            errorText: _emailError,
          ),
          const SizedBox(height: 5),
          Text(
            ':كلمة المرور',
            style: Styles.textStyle15.copyWith(
              color: kprimeryColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 6),
          LoginInputItem(
            hintText: 'example1234',
            prefixIcon: Icons.lock,
            isPassword: true,
            controller: _passwordController,
            errorText: _passwordError,
          ),
          Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ktextColor.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 25),
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              final isLoading = state is LoginLoading;

              return TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: isLoading
                      ? kprimeryColor.withOpacity(0.2)
                      : kprimeryColor.withOpacity(0.4),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  if (isLoading) return;

                  setState(() {
                    _emailError = _emailController.text.isEmpty
                        ? "رجاء ادخل عنوان بريدك الاكتروني"
                        : null;
                    _passwordError = _passwordController.text.isEmpty
                        ? "رجاء ادخل كلمة المرور"
                        : null;
                  });

                  if (_emailError != null || _passwordError != null) {
                    return;
                  }

                  final loginCubit = BlocProvider.of<LoginCubit>(context);
                  loginCubit.setEmail(_emailController.text);
                  loginCubit.setPassword(_passwordController.text);
                  loginCubit.sendLoginDetails();
                },
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'تسجيل دخول',
                          style: Styles.textStyle15.copyWith(color: ktextColor),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  getx.Get.offAll(
                    () => Register(),
                    transition: getx.Transition.noTransition,
                  );
                },
                child: Text(
                  'إنشاء حساب  ',
                  style: Styles.textStyle15.copyWith(color: kprimeryColor),
                ),
              ),
              Text(
                'جديد في المدرسة عزيزي الطالب ؟ ',
                style: Styles.textStyle15.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ktextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
