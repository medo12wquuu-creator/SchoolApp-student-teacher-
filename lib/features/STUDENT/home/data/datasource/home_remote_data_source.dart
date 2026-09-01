library;

import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSource(this.dio);

  // ---------------------------------------------------------
  // 🔵 1) Attendance & Absences
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> getAttendanceAbsences(String token) async {
    final url = '${ApiConstants.baseUrl}${EndPoints.attendanceAbsences}';

    print("📤 SENDING ATTENDANCE/ABSENCES REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            // "Content-Type": "application/json",
          },
        ),
      );

      print("📥 RESPONSE RECEIVED:");
      print("➡️ STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");
      print("➡️ STATUS MESSAGE: ${response.statusMessage}");

      return {
        "statusCode": response.statusCode,
        "attendance": response.data["average"] ?? 0,
        "absences": response.data["absent_days"] ?? 0,
      };
    } catch (e) {
      print("❌ DIO ERROR in getAttendanceAbsences()");
      print("❌ DETAILS: $e");

      return {"statusCode": 0, "attendance": 0, "absences": 0};
    }
  }

  // ---------------------------------------------------------
  // 🟣 2) Events
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> getEvents(String token) async {
    final url = ApiConstants.baseUrl + EndPoints.event;

    print("📤 SENDING EVENTS REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("📥 RESPONSE RECEIVED:");
      print("➡️ STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      return {
        "statusCode": response.statusCode,
        "events": response.data["events"] ?? [],
      };
    } catch (e) {
      print("❌ DIO ERROR in getEvents()");
      print("❌ DETAILS: $e");

      return {"statusCode": 0, "events": []};
    }
  }

  // ---------------------------------------------------------
  // 🟠 3) Tasks
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> getTasks(String token) async {
    final url = '${ApiConstants.baseUrl}${EndPoints.tomorrowTasks}';

    print("📤 SENDING TASKS REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            // "Content-Type": "application/json",
          },
        ),
      );

      print("📥 RESPONSE RECEIVED:");
      print("➡️ STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      return {
        "statusCode": response.statusCode,
        "tasks":
            response.data["tasks"] ?? response.data["tomorrow_tasks"] ?? [],
      };
    } catch (e) {
      print("❌ DIO ERROR in getTasks()");
      print("❌ DETAILS: $e");

      return {"statusCode": 0, "tasks": []};
    }
  }

  // ---------------------------------------------------------
  // 🟢 4) Tomorrow Schedule
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> getSchedule(String token) async {
    final url = '${ApiConstants.baseUrl}${EndPoints.tomorrowSchedule}';

    print("📤 SENDING SCHEDULE REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            // "Content-Type": "application/json",
          },
        ),
      );

      print("📥 RESPONSE RECEIVED:");
      print("➡️ STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      final schedulePayload =
          response.data["schedule"] ??
          response.data["lessons"] ??
          response.data;

      return {
        "statusCode": response.statusCode,
        "schedule": schedulePayload is List ? schedulePayload : [],
      };
    } catch (e) {
      print("❌ DIO ERROR in getSchedule()");
      print("❌ DETAILS: $e");

      return {"statusCode": 0, "schedule": []};
    }
  }

  // ---------------------------------------------------------
  // 🔥 5) Register for an event
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> registerCompetition(
    int eventId,
    String token,
  ) async {
    final url = "${ApiConstants.baseUrl}/event/$eventId/register";
    print("📤 SENDING EVENT REGISTER REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.post(
        url,
        // data: {"event_id": eventId}, // تأكد من اسم المفتاح عند الباك
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print("📥 RESPONSE RECEIVED:");
      print("➡️ STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      return {
        "statusCode": response.statusCode,
        "message": response.data["message"] ?? "",
      };
    } catch (e) {
      print("❌ DIO ERROR in registerCompetition()");
      print("❌ DETAILS: $e");

      return {"statusCode": 0, "message": "Connection failed"};
    }
  }

  // ---------------------------------------------------------
  // 🔑 6) Change Password
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final url = '${ApiConstants.baseUrl}${EndPoints.changePassword}';
    print("📤 SENDING CHANGE PASSWORD REQUEST...");
    print("➡️ URL: $url");

    try {
      final response = await dio.post(
        url,
        data: {
          "current_password": oldPassword,
          "new_password": newPassword,
          "new_password_confirmation": confirmNewPassword,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      print("📥 RESPONSE RECEIVED:");
      print("➡️ STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");

      return {
        "statusCode": response.statusCode,
        "message": response.data["message"] ?? "",
      };
    } catch (e) {
      print("❌ DIO ERROR in changePassword()");
      print("❌ DETAILS: $e");

      return {"statusCode": 0, "message": "Connection failed"};
    }
  }
}
