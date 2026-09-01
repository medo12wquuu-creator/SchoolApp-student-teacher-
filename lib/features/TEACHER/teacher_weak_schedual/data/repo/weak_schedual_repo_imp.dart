import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/data/models/weak_schedual_model/weak_schedual_model.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/data/repo/weak_schedual_repo.dart';

class WeakSchedualRepoImp implements WeakSchedualRepo {
  final ApiService _api;
  WeakSchedualRepoImp(this._api);

  @override
  Future<Either<Failure, WeakSchedualModel>> fetchWeakSchedual() async {
    try {
      final response = await _api.get(endPoint: '/teacher/lessons');
      if (response is Map && response['data'] is Map) {
        return right(
          WeakSchedualModel.fromJson(response['data'] as Map<String, dynamic>),
        );
      }
      if (response is Map) {
        return right(
          WeakSchedualModel.fromJson(response.cast<String, dynamic>()),
        );
      }
      return left(ServerFailure('استجابة غير متوقعة'));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
