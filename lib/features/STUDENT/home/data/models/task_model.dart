import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String subjectName;
  final String title;
  final String description;
  final String deliveryDate;
  final Color accent;
  final IconData icon;

  TaskModel({
    required this.id,
    required this.subjectName,
    required this.title,
    required this.description,
    required this.deliveryDate,
    required this.accent,
    required this.icon,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final subject = json["subject"] as Map<String, dynamic>?;
    final subjectName = subject?["name"] ?? json["subject_name"] ?? "";

    return TaskModel(
      id: json["id"].toString(),
      subjectName: subjectName,
      title: json["type"] ?? "",
      description: json["description"] ?? "",
      deliveryDate: json["delivery_date"] ?? "",
      accent: _defaultAccentColor(json["id"]?.toString() ?? "0"),
      icon: Icons.assignment_outlined,
    );
  }
}

Color _defaultAccentColor(String id) {
  final colors = [
    Color(0xFF0EA5E9),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
  ];

  final index = int.tryParse(id) ?? 0;
  return colors[index % colors.length];
}
