import 'package:flutter/material.dart';

class QrBody extends StatelessWidget {
  final String result;
  const QrBody({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(60),
      child: Text(
        result,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
