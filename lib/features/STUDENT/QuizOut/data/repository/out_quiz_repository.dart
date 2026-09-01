import '../datasource/out_quiz_remote_data_source.dart';
import '../model/out_quiz_model.dart';

class OutQuizRepository {
  final OutQuizRemoteDataSource remote;

  OutQuizRepository(this.remote);

  Future<List<OutQuizModel>> getExams(String token) async {
    final result = await remote.getExams(token);
    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200) {
      final List<dynamic> list = result["quizzes"] ?? [];
      return list
          .map((e) => OutQuizModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        "فشل في تحميل الاختبارات. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.",
      );
    }
  }
}
