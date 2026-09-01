import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:schooly/core/errors/failuree.dart';
import 'package:schooly/features/TEACHER/class_reports/data/models/class_report_model.dart';
import 'package:schooly/features/TEACHER/class_reports/data/repo/class_reports_repo.dart';

import 'package:schooly/core/constants/api_constants.dart';

class ClassReportsRepoImp implements ClassReportsRepo {
  final ApiService apiService;
  ClassReportsRepoImp(this.apiService);

  @override
  Future<Either<Failure, List<ClassReportModel>>> fetchSectionReports({
    required String sectionId,
  }) async {
    try {
      final response = await apiService.get(
        endPoint: '/teacher/reports/section/$sectionId',
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
          .map((e) => ClassReportModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(reports);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure("Parsing Error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, ClassReportModel>> deleteReport({
    required String reportId,
  }) async {
    try {
      final response = await apiService.delete(
        endPoint: '/teacher/report/delete/$reportId',
      );
      if (response is Map && response.isNotEmpty) {
        return right(
          ClassReportModel.fromJson(response.cast<String, dynamic>()),
        );
      }
      return right(ClassReportModel());
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure("Parsing Error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, ClassReportModel>> modifyReport({
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
      final response = await apiService.post(
        endPoint: '/teacher/report/update/$reportId',
        body: body,
      );
      return right(ClassReportModel.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure("Parsing Error: ${e.toString()}"));
    }
  }
}
