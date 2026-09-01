import 'package:flutter/material.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/views/widgets/login_background.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    // أرجعنا الخلفية مباشرة بدون Scaffold زائد يسبب شاشة سوداء
    return const LoginBackground();
  }
}
