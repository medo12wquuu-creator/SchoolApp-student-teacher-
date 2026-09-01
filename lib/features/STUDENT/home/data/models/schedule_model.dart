class ScheduleModel {
  final int subjectId;
  final String subjectName;
  final String teacherFirstName;
  final String startTime;

  ScheduleModel({
    required this.subjectId,
    required this.subjectName,
    required this.teacherFirstName,
    required this.startTime,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final subject = json["subject"] as Map<String, dynamic>? ?? {};
    final teacher = json["teacher"] as Map<String, dynamic>? ?? {};
    final employee = teacher["employee"] as Map<String, dynamic>? ?? {};
    final user = employee["user"] as Map<String, dynamic>? ?? {};
    final person = user["person"] as Map<String, dynamic>? ?? {};
    final timeSlot = json["time_slot"] as Map<String, dynamic>? ?? {};
    final rawStartTime = timeSlot["start_time"] ?? "";

    return ScheduleModel(
      subjectId: json["subject_id"] as int? ?? 0,
      subjectName: subject["name"] ?? "",
      teacherFirstName: person["first_name"] ?? "",
      startTime: _formatStartTime(rawStartTime),
    );
  }
}

String _formatStartTime(dynamic rawTime) {
  if (rawTime is! String || rawTime.isEmpty) return "";
  final parts = rawTime.split(":");
  if (parts.length >= 2) {
    return "${parts[0]}:${parts[1]}";
  }
  return rawTime;
}
