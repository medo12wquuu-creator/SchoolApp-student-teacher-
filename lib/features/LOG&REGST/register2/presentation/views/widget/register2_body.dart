import 'package:flutter/material.dart';
import 'register2_header.dart';
import 'register2_form.dart';

class Register2Body extends StatelessWidget {
  const Register2Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('images/backregister.png', fit: BoxFit.cover),
            Container(color: Colors.white.withOpacity(0.2)),
            Column(
              children: [
                const Register2Header(),
                const Expanded(child: Register2Form()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
