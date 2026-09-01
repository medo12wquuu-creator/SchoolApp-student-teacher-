import 'package:schooly/features/STUDENT/QuizIn/data/models/inner_quiz_model.dart';

import '../datasource/inner_quiz_remote_data_source.dart';

class InnerQuizRepository {
  final InnerQuizRemoteDataSource remote;

  InnerQuizRepository(this.remote);

  Future<InnerQuizStartModel> startExam(String token, int examId) async {
    final result = await remote.startExam(token, examId);
    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200) {
      return InnerQuizStartModel.fromJson(
        result["data"] as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        "فشل في بدء الفحص. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.",
      );
    }
  }

  Future<bool> submitAnswer({
    required String token,
    required int attemptId,
    required int questionId,
    required int optionId,
  }) async {
    final result = await remote.submitAnswer(
      token: token,
      attemptId: attemptId,
      questionId: questionId,
      optionId: optionId,
    );
    final statusCode = result["statusCode"] ?? 0;
    return statusCode == 200 || statusCode == 201;
  }

  Future<InnerQuizSubmitResultModel> submitExam({
    required String token,
    required int attemptId,
  }) async {
    final result = await remote.submitExam(token: token, attemptId: attemptId);
    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200 || statusCode == 201) {
      return InnerQuizSubmitResultModel.fromJson(
        result["data"] as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        "فشل في إرسال الفحص. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.",
      );
    }
  }
}
