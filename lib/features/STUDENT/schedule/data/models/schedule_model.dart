class ScheduleModel {
  final int id;
  final String semesterName;
  final String subjectName;
  final String teacherName;
  final String startTime;
  final String endTime;
  final String sectionName;
  final String classroomName;

  ScheduleModel({
    required this.id,
    required this.semesterName,
    required this.subjectName,
    required this.teacherName,
    required this.startTime,
    required this.endTime,
    required this.sectionName,
    required this.classroomName,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final semesterData = json['semester'] as Map<String, dynamic>? ?? {};
    final subjectData = json['subject'] as Map<String, dynamic>? ?? {};
    final teacherData = json['teacher'] as Map<String, dynamic>? ?? {};
    final employeeData = teacherData['employee'] as Map<String, dynamic>? ?? {};
    final userData = employeeData['user'] as Map<String, dynamic>? ?? {};
    final personData = userData['person'] as Map<String, dynamic>? ?? {};
    final timeSlot = json['time_slot'] as Map<String, dynamic>? ?? {};
    final sectionData = json['section'] as Map<String, dynamic>? ?? {};
    final classroomData =
        sectionData['classroom'] as Map<String, dynamic>? ?? {};

    final firstName = personData['first_name'] as String? ?? '';
    final lastName = personData['last_name'] as String? ?? '';

    return ScheduleModel(
      id: json['id'] as int? ?? 0,
      semesterName: semesterData['name'] as String? ?? '',
      subjectName: subjectData['name'] as String? ?? '',
      teacherName: '$firstName${lastName.isNotEmpty ? ' $lastName' : ''}',
      startTime: timeSlot['start_time'] as String? ?? '',
      endTime: timeSlot['end_time'] as String? ?? '',
      sectionName: sectionData['name'] as String? ?? '',
      classroomName: classroomData['name'] as String? ?? '',
    );
  }
}
