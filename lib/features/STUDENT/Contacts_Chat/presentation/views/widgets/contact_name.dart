import 'package:flutter/material.dart';

class ContactName extends StatelessWidget {
  final String name;

  const ContactName({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.bodyLarge,
    ); // عرض ال name القادم من عند الباك
  }
}
