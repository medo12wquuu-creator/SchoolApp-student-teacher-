class OutQuizModel {
  final int id;
  final String title;
  final String description;
  final int durationMinutes;
  final String startsAt;
  final String endsAt;
  final int totalMarks;
  final int questionsCount;
  final String displayStatus;
  final int? attemptId;
  final int? startsInSeconds;
  final int? remainingSeconds;
  final int? windowEndsInSeconds;
  final num? score;
  final num? percentage;
  final String subjectName;
  final String teacherName;

  const OutQuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.startsAt,
    required this.endsAt,
    required this.totalMarks,
    required this.questionsCount,
    required this.displayStatus,
    this.attemptId,
    this.startsInSeconds,
    this.remainingSeconds,
    this.windowEndsInSeconds,
    this.score,
    this.percentage,
    required this.subjectName,
    required this.teacherName,
  });

  factory OutQuizModel.fromJson(Map<String, dynamic> json) {
    final subject = json["subject"] as Map<String, dynamic>?;
    final teacher = json["teacher"] as Map<String, dynamic>?;

    return OutQuizModel(
      id: _toInt(json["id"]),
      title: json["title"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      durationMinutes: _toInt(json["duration_minutes"]),
      startsAt: json["starts_at"]?.toString() ?? "",
      endsAt: json["ends_at"]?.toString() ?? "",
      totalMarks: _toInt(json["total_marks"]),
      questionsCount: _toInt(json["questions_count"]),
      displayStatus: json["display_status"]?.toString() ?? "",
      attemptId: _toIntOrNull(json["attempt_id"]),
      startsInSeconds: _toIntOrNull(json["starts_in_seconds"]),
      remainingSeconds: _toIntOrNull(json["remaining_seconds"]),
      windowEndsInSeconds: _toIntOrNull(json["window_ends_in_seconds"]),
      score: _toNumOrNull(json["score"]),
      percentage: _toNumOrNull(json["percentage"]),
      subjectName: subject?["name"]?.toString() ?? "",
      teacherName: teacher?["name"]?.toString() ?? "",
    );
  }
}

int _toInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? "") ?? 0;
int? _toIntOrNull(dynamic v) => v == null ? null : _toInt(v);
num? _toNumOrNull(dynamic v) {
  if (v == null) return null;
  return v is num ? v : double.tryParse(v.toString());
}
