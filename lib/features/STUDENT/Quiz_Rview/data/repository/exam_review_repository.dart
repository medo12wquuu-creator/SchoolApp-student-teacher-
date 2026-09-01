import 'package:schooly/features/STUDENT/Quiz_Rview/data/model/exam_review_model.dart';
import '../datasource/exam_review_remote_data_source.dart';

class ExamReviewRepository {
  final ExamReviewRemoteDataSource remote;

  ExamReviewRepository(this.remote);

  Future<ExamReviewResultModel> getResult(String token, int attemptId) async {
    final result = await remote.getResult(token, attemptId);
    final statusCode = result["statusCode"] ?? 0;

    if (statusCode == 200) {
      return ExamReviewResultModel.fromJson(
        result["data"] as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        "فشل في تحميل نتيجة الاختبار. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.",
      );
    }
  }
}
