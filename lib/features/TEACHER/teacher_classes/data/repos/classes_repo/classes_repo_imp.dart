import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/teacher_classes_model/teacher_classes_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/classes_repo/classes_repo.dart';

class ClassesRepoImp implements ClassesRepo {
  final ApiService _api;

  ClassesRepoImp(this._api);

  @override
  Future<Either<Failure, TeacherClassesModel>> fetchTeacherClasses() async {
    try {
      final response = await _api.get(endPoint: '/teacherSections');

      if (response is List) {
        return right(TeacherClassesModel.fromList(response));
      }
      if (response is Map<String, dynamic>) {
        return right(TeacherClassesModel.fromJson(response));
      }
      return left(ServerFailure('استجابة غير متوقعة من الخادم'));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
