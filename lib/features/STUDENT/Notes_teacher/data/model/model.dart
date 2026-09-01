import 'dart:io';

class TeacherNoteModel {
  final int id;
  final String body;
  final String type;
  final DateTime createdAt;
  final String teacherFirstName;
  final String teacherLastName;
  final File? teacherPhotoFile;
  final String? teacherPhotoUrl;
  final String subjectName;

  TeacherNoteModel({
    required this.id,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.teacherFirstName,
    required this.teacherLastName,
    this.teacherPhotoFile,
    this.teacherPhotoUrl,
    required this.subjectName,
  });

  String get teacherFullName => '$teacherFirstName $teacherLastName';

  factory TeacherNoteModel.fromJson(
    Map<String, dynamic> json, {
    String? downloadedPhotoUrl,
  }) {
    final teacher = json['teacher'] is Map
        ? Map<String, dynamic>.from(json['teacher'])
        : null;
    final employee = teacher != null && teacher['employee'] is Map
        ? Map<String, dynamic>.from(teacher['employee'])
        : null;
    final user = employee != null && employee['user'] is Map
        ? Map<String, dynamic>.from(employee['user'])
        : null;
    final person = user != null && user['person'] is Map
        ? Map<String, dynamic>.from(user['person'])
        : null;

    final subject = json['subject'] is Map
        ? Map<String, dynamic>.from(json['subject'])
        : null;

    final personalPhotoValue =
        person?['personal_photo'] ?? person?['personalPhoto'];

    File? photoFile;
    if (personalPhotoValue is File) {
      photoFile = personalPhotoValue;
    }

    return TeacherNoteModel(
      id: json['id'] ?? 0,
      body: json['body']?.toString() ?? '',
      type: json['type']?.toString() ?? 'positive',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      teacherFirstName: person?['first_name']?.toString() ?? '',
      teacherLastName: person?['last_name']?.toString() ?? '',
      teacherPhotoFile: photoFile,
      teacherPhotoUrl: downloadedPhotoUrl,
      subjectName: subject?['name']?.toString() ?? '',
    );
  }
}
