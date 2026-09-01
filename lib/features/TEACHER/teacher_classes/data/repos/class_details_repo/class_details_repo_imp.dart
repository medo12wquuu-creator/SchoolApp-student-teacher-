import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/fetch_attendance/take_attendance.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/fetch_homework_and_task_model/fetch_homework_and_task_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/send_class_report_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/send_homework_and_task_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/take_attendance_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';

class ClassDetailsRepoImp implements ClassDetailsRepo {
  final ApiService _api;
  ClassDetailsRepoImp(this._api);

  @override
  Future<Either<Failure, SendHomeworkAndTaskModel>> sendHomework({
    required String sectionId,
    required String type,
    required String title,
    required String description,
    required String deliveryDate,
    int? subjectId,
  }) async {
    return _sendActivity(
      sectionId: sectionId,
      type: 'homework',
      title: title,
      description: description,
      deliveryDate: deliveryDate,
      subjectId: subjectId,
    );
  }

  @override
  Future<Either<Failure, SendHomeworkAndTaskModel>> sendTask({
    required String sectionId,
    required String type,
    required String title,
    required String description,
    required String deliveryDate,
    int? subjectId,
  }) async {
    return _sendActivity(
      sectionId: sectionId,
      type: 'Quiz',
      title: title,
      description: description,
      deliveryDate: deliveryDate,
      subjectId: subjectId,
    );
  }

  Future<Either<Failure, SendHomeworkAndTaskModel>> _sendActivity({
    required String sectionId,
    required String type,
    required String title,
    required String description,
    required String deliveryDate,
    int? subjectId,
  }) async {
    try {
      // إرسال القيم كـ String مباشرة دون استخدام int.parse
      final body = {
        'section_id': sectionId,
        'type': type,
        'title': title,
        'description': description,
        'delivery_date': deliveryDate,
        'subject_id': ?subjectId,
      };
      debugPrint("البيانات المرسلة للسيرفر: ${body.toString()}");
      final response = await _api.post(
        endPoint: '/teacher/storeTaskAndHomework',
        body: body,
      );

      return right(SendHomeworkAndTaskModel.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FetchHomeworkAndTaskModel>>> fetchHomework(
    String sectionId,
  ) async {
    return _fetchActivities(sectionId, 'homework');
  }

  @override
  Future<Either<Failure, List<FetchHomeworkAndTaskModel>>> fetchTasks(
    String sectionId,
  ) async {
    return _fetchActivities(sectionId, 'Quiz');
  }

  Future<Either<Failure, List<FetchHomeworkAndTaskModel>>> _fetchActivities(
    String sectionId,
    String type,
  ) async {
    try {
      final response = await _api.get(
        endPoint: '/teacher/tasksAndHomework/$sectionId',
      );
      final List<dynamic> rawList;
      if (response is List) {
        rawList = response;
      } else if (response['data'] is List) {
        rawList = response['data'] as List<dynamic>;
      } else {
        return left(ServerFailure('استجابة غير متوقعة'));
      }
      final items = rawList
          .map(
            (e) =>
                FetchHomeworkAndTaskModel.fromJson(e as Map<String, dynamic>),
          )
          .where((item) => item.type == type)
          .toList();
      return right(items);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FetchAttendanceModel>> fetchAttendance({
    required String sectionId,
  }) async {
    try {
      final response = await _api.get(
        endPoint: '/teacher/section/$sectionId/attendance/today',
      );

      debugPrint("📥 استجابة سيرفر الحضور: $response");

      Map<String, dynamic> targetJson = {};

      if (response is Map<String, dynamic>) {
        if (response.containsKey('data') &&
            response['data'] is Map<String, dynamic>) {
          targetJson = response['data'] as Map<String, dynamic>;
        } else {
          targetJson = response;
        }
      }

      final model = FetchAttendanceModel.fromJson(targetJson);
      return right(model);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TakeAttendanceModel>> takeAttendance({
    required String sectionId,
    required List<Map<String, dynamic>> attendances,
  }) async {
    try {
      final body = {
        // إذا كان السيرفر يحتاج section_id يمكنك تركه
        'section_id': int.tryParse(sectionId) ?? sectionId,
        'students':
            attendances, // 🟢 تم التغيير من 'attendances' إلى 'students'
      };

      debugPrint("📤 إرسال بيانات الحضور للباك إند: $body");

      final response = await _api.post(
        endPoint: '/teacher/section/$sectionId/attendance/bulk',
        body: body,
      );

      return right(
        TakeAttendanceModel.fromJson(response.cast<String, dynamic>()),
      );
      return left(ServerFailure('استجابة غير متوقعة'));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SendClassReportModel>> sendClassReport({
    required String sectionId,
    required String title,
    required String description,
  }) async {
    try {
      final body = {
        'section_id': sectionId,
        'title': title,
        'description': description,
      };
      debugPrint("📤 إرسال تقرير الشعبة للباك إند: $body");
      final response = await _api.post(
        endPoint: '/teacher/report/store',
        body: body,
      );
      return right(SendClassReportModel.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TakeAttendanceModel>> modifyAttendance({
    required String sectionId,
    required List<Map<String, dynamic>> attendances,
  }) {
    // TODO: implement modifyAttendance
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, dynamic>> deleteTaskHomework(int id) async {
    try {
      final response = await _api.delete(endPoint: '/teacher/deleteTask/$id');
      debugPrint("🗑️ حذف مهمة/واجب: $response");
      return right(response);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
