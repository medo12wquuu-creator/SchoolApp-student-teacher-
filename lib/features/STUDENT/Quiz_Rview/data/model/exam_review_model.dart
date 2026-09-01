class ExamReviewDetailModel {
  final String question;
  final num marks;
  final bool isCorrect;
  final String? selectedOption;
  final String? correctOption;

  const ExamReviewDetailModel({
    required this.question,
    required this.marks,
    required this.isCorrect,
    this.selectedOption,
    this.correctOption,
  });

  factory ExamReviewDetailModel.fromJson(Map<String, dynamic> json) {
    return ExamReviewDetailModel(
      question: json["question"]?.toString() ?? "",
      marks: _toNum(json["marks"]),
      isCorrect: json["is_correct"] == true,
      selectedOption: json["selected_option"]?.toString(),
      correctOption: json["correct_option"]?.toString(),
    );
  }
}

class ExamReviewResultModel {
  final String message;
  final num score;
  final num total;
  final num percentage;
  final String status;
  final List<ExamReviewDetailModel> details;

  const ExamReviewResultModel({
    required this.message,
    required this.score,
    required this.total,
    required this.percentage,
    required this.status,
    required this.details,
  });

  factory ExamReviewResultModel.fromJson(Map<String, dynamic> json) {
    final detailsJson = json["details"] as List<dynamic>? ?? [];
    return ExamReviewResultModel(
      message: json["message"]?.toString() ?? "",
      score: _toNum(json["score"]),
      total: _toNum(json["total"]),
      percentage: _toNum(json["percentage"]),
      status: json["status"]?.toString() ?? "",
      details: detailsJson
          .map((e) => ExamReviewDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

num _toNum(dynamic v) {
  if (v is num) return v;
  return num.tryParse(v?.toString() ?? "") ?? 0;
}
