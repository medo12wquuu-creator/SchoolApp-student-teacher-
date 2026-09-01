// import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as getx;
import 'package:schooly/core/constants/imagess.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/views/login.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_cubit.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/views/widget/register_field.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // final player = AudioPlayer();
    final phoneController = TextEditingController();
    // final firstNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          decoration: BoxDecoration(
            // الزجاج الشفاف
            color: Colors.white.withValues(alpha: 0.16),

            borderRadius: BorderRadius.circular(18),

            // حواف زجاجية
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.30),
              width: 1,
            ),

            // ظل ناعم
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Image.asset(
                      'images/check.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),

                    Text(
                      "    إنشاء حساب",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                Text(
                  " عزيزي الطالب , قم بملئ البيانات التالية لتسجيل حسابك",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // ============ =========== First Name Field =======================
                // Text(
                //   "الاسم الأول",
                //   style: TextStyle(
                //     color: kAccountTextColor,
                //     fontSize: 15,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                // RegisterField(
                //   controller: firstNameController,
                //   hintText: "الاسم الأول",
                //   icon: Icons.person_outline,
                //   obscuretxt: false,
                //   validator: (value) =>
                //       value!.isEmpty ? "First name is required" : null,
                //   onchange: (v) => context.read<RegisterCubit>().setFirstName(v!),
                // ),

                // ======================= Last Name Field =======================
                // Text(
                //   "Last Name",
                //   style: TextStyle(
                //     color: kAccountTextColor,
                //     fontSize: 15,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                // RegisterField(
                //   controller: lastNameController,
                //   hintText: "Last Name",
                //   icon: Icons.person,
                //   obscuretxt: false,
                //   validator: (value) =>
                //       value!.isEmpty ? "Last name is required" : null,
                //   onchange: (v) => context.read<RegisterCubit>().setLastName(v!),
                // ),
                SizedBox(height: 16),

                // ======================= Email Field =======================
                Text(
                  "البريد الإلكتروني",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                RegisterField(
                  controller: emailController,
                  hintText: "name@gmail.com",
                  icon: Icons.person,
                  obscuretxt: false,
                  validator: (value) {
                    if (value!.isEmpty) return "Email is required";
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                  onchange: (v) => context.read<RegisterCubit>().setEmail(v!),
                  keyboard: TextInputType.emailAddress,
                ),

                SizedBox(height: 16),

                // ======================= Phone Number Field =======================
                Text(
                  "رقم الهاتف",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                RegisterField(
                  controller: phoneController,
                  hintText: "أدخل رقم هاتفك",
                  icon: Icons.person,
                  obscuretxt: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "رقم الهاتف مطلوب";
                    } else if (value.length < 10) {
                      return "رقم الهاتف أقل من 10 أرقام، حاول مرة أخرى";
                    } else if (value.length > 10) {
                      return "رقم الهاتف أكثر من 10 أرقام، حاول مرة أخرى";
                    } else {
                      return null;
                    }
                  },
                  onchange: (v) => context.read<RegisterCubit>().setPhone(v!),
                  keyboard: TextInputType.number,
                ),

                SizedBox(height: 16),

                // ======================= Password Field =======================
                Text(
                  "كلمة المرور",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                RegisterField(
                  controller: passwordController,
                  hintText: "أدخل كلمة المرور",
                  icon: Icons.lock,
                  obscuretxt: true,
                  showPasswordToggle: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "كلمة المرور مطلوبة";
                    }

                    // الحد الأدنى للطول
                    if (value.length < 8) {
                      return "كلمة المرور يجب أن تكون على الأقل 8 أحرف";
                    }

                    // حرف كبير
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "يجب أن تحتوي كلمة المرور على حرف كبير على الأقل";
                    }

                    // حرف صغير
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return "يجب أن تحتوي كلمة المرور على حرف صغير على الأقل";
                    }

                    // رقم
                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return "يجب أن تحتوي كلمة المرور على رقم على الأقل";
                    }

                    // رمز
                    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                      return "يجب أن تحتوي كلمة المرور على رمز خاص على الأقل (! @ # \$ & * ~)";
                    }

                    return null;
                  },
                  onchange: (v) =>
                      context.read<RegisterCubit>().setPassword(v!),
                  keyboard: TextInputType.visiblePassword,
                ),

                InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      context.read<RegisterCubit>().register();
                    }
                  },
                  child: Image.asset(signup, height: 100),
                ),
                // IconButton(
                //   icon: Image.asset(signup),
                //   onPressed: () {
                //     print("تم الضغط");
                //   },
                // ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        getx.Get.offAll(
                          () => const Login(),
                          transition: getx.Transition.noTransition,
                        );
                      },
                      child: Text(
                        "        بتسجيل الدخول ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      " اذا لديك حساب بالفعل, قم  ",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),

                // ElevatedButton(
                //   onPressed: () async {
                //     await player.play(AssetSource('sounds/succes.mp3'));
                //   },
                //   child: Text("صوت النجاح"),
                // ),
                // ElevatedButton(
                //   onPressed: () async {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => StudentMainLayout()),
                //     );
                //   },
                //   child: Text("HOME PAGE"),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const QrScannerPage(),
                //       ),
                //     );
                //   },
                //   child: Text("QR Responce"),
                // ),
                // FlashToggleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
