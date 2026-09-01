import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/fetch_teacher_profile_model/fetch_teacher_profile_model.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/today_schedual_model/today_schedual_model.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/repos/teacher_home_repo.dart';

class TeacherHomeRepoIm implements TeacherHomeRepo {
  final ApiService apiService;
  TeacherHomeRepoIm(this.apiService);

  @override
  Future<Either<Failure, List<TodaySchedualModel>>> fetchTodaySchedual() async {
    try {
      var response = await apiService.get(endPoint: '/teacher/todayLessons');
      List<TodaySchedualModel> todaySchedual = [];
      var rawList =
          response['data'] ?? response['items'] ?? response['lessons'];
      if (rawList != null && rawList is List) {
        for (var element in rawList) {
          todaySchedual.add(
            TodaySchedualModel.fromJson(element as Map<String, dynamic>),
          );
        }
      }
      return Right(todaySchedual);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure("Parsing Error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, String>> fetchTeacherName() async {
    try {
      var response = await apiService.get(endPoint: '/teacher/profile');
      if (response['name'] != null) {
        return Right(response['name'] as String);
      }
      return left(ServerFailure('Failed to load teacher name'));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure("Parsing Error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, FetchTeacherProfileModel>> fetchProfileInfo() async {
    try {
      var response = await apiService.get(endPoint: '/teacherProfile');
      if (response is Map && response['data'] is Map) {
        return right(
          FetchTeacherProfileModel.fromJson(
            response['data'] as Map<String, dynamic>,
          ),
        );
      }
      if (response is Map) {
        return right(
          FetchTeacherProfileModel.fromJson(response.cast<String, dynamic>()),
        );
      }
      return left(ServerFailure('استجابة غير متوقعة'));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure("Parsing Error: ${e.toString()}"));
    }
  }
}
