import 'package:flutter/material.dart';

class AnnouncementDescription extends StatelessWidget {
  final String description;

  const AnnouncementDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      // هنا اضع ال body القادم من عند الباك
      description,
      style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.5),
    );
  }
}
