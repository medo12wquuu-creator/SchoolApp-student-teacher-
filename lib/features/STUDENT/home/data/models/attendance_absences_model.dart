class AttendanceAbsencesModel {
  final dynamic attendance;
  final dynamic absences;

  AttendanceAbsencesModel({required this.attendance, required this.absences});

  factory AttendanceAbsencesModel.fromJson(Map<String, dynamic> json) {
    return AttendanceAbsencesModel(
      attendance: json["average"] ?? 0,
      absences: json["absent_days"] ?? 0,
    );
  }
}
