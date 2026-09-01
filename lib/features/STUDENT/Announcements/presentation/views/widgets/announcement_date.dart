import 'package:flutter/material.dart';

class AnnouncementDate extends StatelessWidget {
  final String date;

  const AnnouncementDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Text(
      // هنا اضع تاريخ انشاء القدام من عند الباك
      date,
      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
    );
  }
}
