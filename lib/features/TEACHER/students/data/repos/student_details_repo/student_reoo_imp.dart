import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/students/data/models/add_note/add_note.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_student_reports/fetch_student_reports.dart';
import 'package:schooly/features/TEACHER/students/data/models/notes_model/notes_model.dart';
import 'package:schooly/features/TEACHER/students/data/models/send_repots.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_details_repo.dart';

class StudentDetailsRepoImpl implements StudentDetailsRepo {
  final ApiService _api;
  StudentDetailsRepoImpl(this._api);

  @override
  Future<Either<Failure, List<NotesModel>>> fetchStudentNotes({
    required String studentId,
  }) async {
    try {
      final response = await _api.get(
        endPoint: '/getNotesByTeacherOnStudent/$studentId',
      );
      final List<dynamic> rawList;
      if (response is List) {
        rawList = response;
      } else if (response is Map && response['notes'] is List) {
        rawList = response['notes'] as List<dynamic>;
      } else if (response is Map && response['data'] is List) {
        rawList = response['data'] as List<dynamic>;
      } else {
        return left(ServerFailure('استجابة غير متوقعة'));
      }
      final notes = rawList
          .map((e) => NotesModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(notes);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddNote>> sendStudentNote({
    required String studentId,
    required String subjectId,
    required String semesterId,
    required String type,
    required String body,
  }) async {
    try {
      final response = await _api.post(
        endPoint: '/StoreNotes',
        body: {
          'student_id': studentId,
          'subject_id': subjectId,
          'semester_id': semesterId,
          'type': type,
          'body': body,
        },
      );
      return right(AddNote.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FetchStudentReports>>> fetchStudentReports({
    required String studentId,
  }) async {
    try {
      final response = await _api.get(
        endPoint: '/teacher/reports/student/$studentId',
      );
      final List<dynamic> rawList;
      if (response is List) {
        rawList = response;
      } else if (response is Map && response['reports'] is List) {
        rawList = response['reports'] as List<dynamic>;
      } else if (response is Map && response['data'] is List) {
        rawList = response['data'] as List<dynamic>;
      } else {
        return left(ServerFailure('استجابة غير متوقعة'));
      }
      final reports = rawList
          .map((e) => FetchStudentReports.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(reports);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SendRepots>> sendStudentReport({
    required String studentId,
    required String title,
    required String description,
    required String type,
  }) async {
    try {
      final response = await _api.post(
        endPoint: '/teacher/report/store',
        body: {
          'student_id': studentId,
          'title': title,
          'description': description,
          'type': type,
        },
      );
      return right(SendRepots.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FetchStudentReports>> deleteStudentReport({
    required String reportId,
  }) async {
    try {
      final response = await _api.delete(
        endPoint: '/teacher/report/delete/$reportId',
      );
      if (response is Map && response.isNotEmpty) {
        return right(
          FetchStudentReports.fromJson(response.cast<String, dynamic>()),
        );
      }
      return right(FetchStudentReports());
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FetchStudentReports>> modifyStudentReport({
    required String reportId,
    String? title,
    String? description,
  }) async {
    try {
      final body = <String, dynamic>{
        if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
      };
      final response = await _api.post(
        endPoint: '/teacher/report/update/$reportId',
        body: body,
      );
      return right(FetchStudentReports.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
