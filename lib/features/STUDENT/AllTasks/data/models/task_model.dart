import 'package:flutter/material.dart';

class TaskModel {
  final int id;
  final String type;
  final String description;
  final String deliveryDate;
  final String subjectName;
  final String teacherName;
  final Color accent;

  const TaskModel({
    required this.id,
    required this.type,
    required this.description,
    required this.deliveryDate,
    required this.subjectName,
    required this.teacherName,
    required this.accent,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final subject = json["subject"] as Map<String, dynamic>?;
    final teacher = json["teacher"] as Map<String, dynamic>?;
    final employee = teacher?["employee"] as Map<String, dynamic>?;
    final user = employee?["user"] as Map<String, dynamic>?;
    final person = user?["person"] as Map<String, dynamic>?;

    final firstName = person?["first_name"]?.toString() ?? "";
    final lastName = person?["last_name"]?.toString() ?? "";
    final teacherName = [
      firstName,
      lastName,
    ].where((s) => s.trim().isNotEmpty).join(" ");

    final id = json["id"] is int
        ? json["id"]
        : int.tryParse(json["id"]?.toString() ?? "0") ?? 0;
    final type = json["type"]?.toString() ?? "";

    return TaskModel(
      id: id,
      type: type,
      description: json["description"]?.toString() ?? "",
      deliveryDate: json["delivery_date"]?.toString() ?? "",
      subjectName: subject?["name"]?.toString() ?? "",
      teacherName: teacherName,
      accent: _defaultAccentColor(id),
    );
  }
}

Color _defaultAccentColor(int id) {
  final colors = [
    const Color(0xFF0EA5E9),
    const Color(0xFF22C55E),
    const Color(0xFFF59E0B),
    const Color(0xFF8B5CF6),
    const Color(0xFFEC4899),
  ];
  return colors[id % colors.length];
}
