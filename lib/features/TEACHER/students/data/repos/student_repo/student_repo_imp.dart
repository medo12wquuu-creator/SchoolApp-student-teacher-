import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_students_model/fetch_students_model.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_weights_model/fetch_weights_model.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_repo/student_repo.dart';

class StudentRepoImp implements StudentRepo {
  final ApiService _api;
  StudentRepoImp(this._api);

  @override
  Future<Either<Failure, StudentsAndWeights>> fetchStudents({
    required String sectionId,
    required String semesterId,
  }) async {
    try {
      final response = await _api.get(
        endPoint: '/sectionGrade',
        queryParameters: {'section_id': sectionId, 'semester_id': semesterId},
      );

      final List<dynamic> rawStudents;
      final List<dynamic> rawWeights = [];
      if (response is List) {
        rawStudents = response;
      } else if (response is Map && response['students'] is List) {
        // 🟢 استخراج الطلاب والأوزان من نفس الاستجابة
        rawStudents = response['students'] as List<dynamic>;
        if (response['weights'] is List) {
          rawWeights.addAll(response['weights'] as List<dynamic>);
        }
      } else if (response is Map && response['data'] is List) {
        rawStudents = response['data'] as List<dynamic>;
      } else {
        return left(ServerFailure('استجابة غير متوقعة'));
      }

      final students = rawStudents
          .map((e) => FetchStudentsModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final weights = rawWeights
          .map((e) => FetchWeightsModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right((students: students, weights: weights));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FetchWeightsModel>>> fetchWheights({
    required String sectionId,
    required String semesterId,
  }) async {
    try {
      final response = await _api.get(
        endPoint: '/subjectWeights',
        queryParameters: {'section_id': sectionId, 'semester_id': semesterId},
      );

      final List<dynamic> rawList;
      if (response is List) {
        rawList = response;
      } else if (response is Map && response['weights'] is List) {
        // 🟢 تم التعديل للتحقق من مفتاح weights أولاً
        rawList = response['weights'] as List<dynamic>;
      } else if (response is Map && response['data'] is List) {
        rawList = response['data'] as List<dynamic>;
      } else {
        return left(ServerFailure('استجابة غير متوقعة'));
      }

      final weights = rawList
          .map((e) => FetchWeightsModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(weights);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendSingleMark({
    required String sectionId,
    required String semesterId,
    required String studentId,
    required String weightId,
    required String score,
  }) async {
    try {
      // 🟢 تم تغيير الاسم هنا إلى subject_grade_weight_id ليتطابق مع متطلبات السيرفر
      await _api.post(
        endPoint:
            '/storeGrade?student_id=$studentId&subject_grade_weight_id=$weightId',
        body: {
          'section_id': sectionId,
          'semester_id': semesterId,
          'score': score,
        },
      );
      return right(null);
    } on DioException catch (e) {
      if (e.response != null) {
        print("🔴 Server validation error (422): ${e.response?.data}");
      }
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
