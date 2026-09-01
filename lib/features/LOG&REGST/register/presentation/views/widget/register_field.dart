import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

class RegisterField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscuretxt;
  final bool showPasswordToggle;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final void Function(String?)? onchange;

  final IconData? icon;

  const RegisterField({
    super.key,
    required this.obscuretxt,
    this.showPasswordToggle = false,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.validator,
    required this.onchange,
    this.keyboard,
  });

  @override
  State<RegisterField> createState() => _RegisterFieldState();
}

class _RegisterFieldState extends State<RegisterField> {
  late bool _obscure = widget.obscuretxt;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscuretxt ? _obscure : false,
          keyboardType: widget.keyboard ?? TextInputType.text,
          onChanged: widget.onchange,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: kHintTextColor, fontSize: 14),
            prefixIcon: Icon(widget.icon, color: kSecondlyColor),
            suffixIcon: widget.showPasswordToggle
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                      color: kSecondlyColor,
                    ),
                  )
                : null,

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
          validator: widget.validator,
        ),
      ),
    );
  }
}
