// import '../datasource/home_remote_data_source.dart';
// import '../models/attendance_absences_model.dart';

// class HomeRepository {
//   final HomeRemoteDataSource remote;

//   HomeRepository(this.remote);

//   Future<AttendanceAbsencesModel> getAttendanceAbsences() async {
//     final result = await remote.getAttendanceAbsences();

//     return AttendanceAbsencesModel.fromJson(result);
//   }
// }
import 'dart:io';

import 'package:dio/dio.dart';

import '../datasource/home_remote_data_source.dart';
import '../models/attendance_absences_model.dart';
import '../models/event_model.dart';
import '../models/task_model.dart';
import '../models/schedule_model.dart';

class HomeRepository {
  final HomeRemoteDataSource remote;

  HomeRepository(this.remote);

  // ---------------------------------------------------------
  // 🔵 1) Attendance & Absences
  // ---------------------------------------------------------
  Future<AttendanceAbsencesModel> getAttendanceAbsences(String token) async {
    final result = await remote.getAttendanceAbsences(token);

    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200) {
      return AttendanceAbsencesModel(
        attendance: (result["attendance"] ?? 0).toDouble(),
        absences: result["absences"] ?? 0,
      );
    } else {
      throw Exception(
        "فشل في تحميل الحضور والغياب. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.",
      );
    }
  }

  // ---------------------------------------------------------
  // 🟣 2) Events
  // ---------------------------------------------------------
  Future<List<EventsModel>> getEvents(String token) async {
    final result = await remote.getEvents(token);

    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200) {
      final List<dynamic> list = result["events"] ?? [];
      final models = list
          .map((e) => EventsModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // ننزّل كل صورة إلى ملف مؤقت (نفس نمط OutChat)
      return Future.wait(
        models.map((model) async {
          final file = await _downloadImage(
            EventsModel.resolveImageUrl(model.imageUrl),
          );
          return model.copyWith(imageFile: file);
        }),
      );
    } else {
      throw Exception(
        "فشل في تحميل الأحداث. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.",
      );
    }
  }

  // ---------------------------------------------------------
  // 🟠 3) Tasks
  // ---------------------------------------------------------
  Future<List<TaskModel>> getTasks(String token) async {
    final result = await remote.getTasks(token);

    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200) {
      final List<dynamic> list = result["tasks"] ?? [];
      return list.map((e) => TaskModel.fromJson(e)).toList();
    } else {
      throw Exception(
        "فشل في تحميل المهام . تأكد من اتصالك بالإنترنت وحاول مرة أخرى.",
      );
    }
  }

  // ---------------------------------------------------------
  // 🟢 4) Tomorrow Schedule
  // ---------------------------------------------------------
  Future<List<ScheduleModel>> getSchedule(String token) async {
    final result = await remote.getSchedule(token);

    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200) {
      final List<dynamic> list =
          result["schedule"] as List<dynamic>? ??
          result["lessons"] as List<dynamic>? ??
          [];
      return list.map((e) => ScheduleModel.fromJson(e)).toList();
    } else {
      throw Exception(
        "فشل في تحميل الجدول. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.",
      );
    }
  }

  // ---------------------------------------------------------
  // 🔥 5) Register for an event
  // ---------------------------------------------------------
  Future<String> registerCompetition(int eventId, String token) async {
    final result = await remote.registerCompetition(eventId, token);

    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200) {
      return result["message"] ?? "Success";
    } else {
      throw Exception(result["message"] ?? "فشل في انشاء الحساب.");
    }
  }

  Future<File?> _downloadImage(String url) async {
    if (url.isEmpty) return null;
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final dir = Directory.systemTemp;
      final file = File(
        '${dir.path}/event_${DateTime.now().microsecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(response.data ?? const []);
      return file;
    } catch (_) {
      return null;
    }
  }
}
