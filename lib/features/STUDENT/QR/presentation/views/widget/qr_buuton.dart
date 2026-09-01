import 'package:flutter/material.dart';

class QrViewWidget extends StatelessWidget {
  final String message;
  const QrViewWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: const TextStyle(fontSize: 18)));
  }
}
