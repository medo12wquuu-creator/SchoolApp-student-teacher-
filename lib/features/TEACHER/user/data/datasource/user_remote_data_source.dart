import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

import 'package:schooly/core/errors/failure.dart';

class UserRemoteDataSource {
  final ApiService apiService;

  UserRemoteDataSource(this.apiService);

  /// جلب بيانات المستخدم الحالي باستخدام التوكن
  Future<Either<Failure, Map<String, dynamic>>> getUser(String token) async {
    try {
      final response = await apiService.get(
        endPoint: '/teacher/profile',
        token: token,
      );
      return right(_unwrap(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure('Parsing Error: ${e.toString()}'));
    }
  }

  /// تحديث بيانات المستخدم — السيرفر يعرف المستخدم من التوكن
  Future<Either<Failure, Map<String, dynamic>>> updateUser(
    String token,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await apiService.post(
        endPoint: '/updateTeacherProfile',
        body: body,
        token: token,
      );
      return right(_unwrap(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure('Parsing Error: ${e.toString()}'));
    }
  }

  /// بعض الاستجابات تأتي مغلفة بـ data أو teacher — نفك التغليف هنا
  Map<String, dynamic> _unwrap(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        return response['data'] as Map<String, dynamic>;
      }
      if (response['teacher'] is Map<String, dynamic>) {
        return response['teacher'] as Map<String, dynamic>;
      }
      return response;
    }
    return {};
  }
}
