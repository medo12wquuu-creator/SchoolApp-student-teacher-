import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/fetch_quiz_score_model/fetch_quiz_score_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/fetch_quizzes_model/fetch_quizzes_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/send_quiz_model/send_quiz_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/teacher_quiz_repo.dart';

class TeacherQuizzesDetailsRepoImp implements TeacherQuizzesDetailsRepo {
  final ApiService _api;
  TeacherQuizzesDetailsRepoImp(this._api);

  @override
  Future<Either<Failure, SendQuizModel>> sendTeacherQuizzes({
    required Map<String, dynamic> quizData,
  }) async {
    try {
      debugPrint("📤 إرسال بيانات الكويز للباك إيند: $quizData");
      final response = await _api.post(endPoint: '/exams', body: quizData);

      return right(SendQuizModel.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FetchQuizzesModel>> fetchTeacherQuizzes() async {
    try {
      final response = await _api.get(endPoint: '/exams');
      return right(
        FetchQuizzesModel.fromJson(response as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SendQuizModel>> fetchTeacherQuizDetails({
    required int quizId,
  }) async {
    try {
      final response = await _api.get(endPoint: '/exams/$quizId');
      return right(SendQuizModel.fromJson(response as Map<String, dynamic>));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SendQuizModel>> updateTeacherQuiz({
    required int quizId,
    required Map<String, dynamic> quizData,
  }) async {
    try {
      debugPrint("🔄 تعديل الكويز (POST): $quizData");
      final response = await _api.post(
        endPoint: '/exams/$quizId/update',
        body: quizData,
      );
      return right(SendQuizModel.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SendQuizModel>> publishTeacherQuiz({
    required int quizId,
  }) async {
    try {
      final response = await _api.post(
        endPoint: '/exams/$quizId/publish',
        body: const {},
      );
      return right(SendQuizModel.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTeacherQuiz({required int quizId}) async {
    try {
      await _api.delete(endPoint: '/exams/$quizId');
      return right(true);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FetchQuizScoreModel>> fetchQuizScore({
    required int quizId,
  }) async {
    try {
      final response = await _api.get(endPoint: '/exams/$quizId/results');
      return right(
        FetchQuizScoreModel.fromJson(response as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
