import 'package:dartz/dartz.dart';

import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/fetch_quiz_score_model/fetch_quiz_score_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/fetch_quizzes_model/fetch_quizzes_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/send_quiz_model/send_quiz_model.dart';

abstract class TeacherQuizzesDetailsRepo {
  Future<Either<Failure, SendQuizModel>> sendTeacherQuizzes({
    required Map<String, dynamic> quizData,
  });

  Future<Either<Failure, FetchQuizzesModel>> fetchTeacherQuizzes();

  Future<Either<Failure, SendQuizModel>> fetchTeacherQuizDetails({
    required int quizId,
  });

  Future<Either<Failure, SendQuizModel>> updateTeacherQuiz({
    required int quizId,
    required Map<String, dynamic> quizData,
  });

  Future<Either<Failure, SendQuizModel>> publishTeacherQuiz({
    required int quizId,
  });

  Future<Either<Failure, bool>> deleteTeacherQuiz({required int quizId});

  /// جلب علامات الطلاب لكويز مغلق (submitted / timeout / not_attempted)
  Future<Either<Failure, FetchQuizScoreModel>> fetchQuizScore({
    required int quizId,
  });
}
