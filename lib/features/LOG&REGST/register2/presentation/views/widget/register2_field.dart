import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class Register2Field extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscuretxt;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final void Function(String?)? onchange;
  final IconData? icon;

  const Register2Field({
    super.key,
    required this.obscuretxt,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.validator,
    required this.onchange,
    this.keyboard,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: TextFormField(
          controller: controller,
          obscureText: obscuretxt,
          keyboardType: keyboard ?? TextInputType.text,
          onChanged: onchange,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: kHintTextColor, fontSize: 14),
            prefixIcon: Icon(icon, color: kSecondlyColor),
            filled: true,
            fillColor: kGroundColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 193, 193, 193),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 68, 136, 199),
                width: 1.4,
              ),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          validator: validator,
        ),
      ),
    );
  }
}
