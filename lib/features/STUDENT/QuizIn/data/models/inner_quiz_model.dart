class InnerQuizOptionModel {
  final int id;
  final String body;
  final int order;

  const InnerQuizOptionModel({
    required this.id,
    required this.body,
    required this.order,
  });

  factory InnerQuizOptionModel.fromJson(Map<String, dynamic> json) {
    return InnerQuizOptionModel(
      id: _toInt(json["id"]),
      body: json["body"]?.toString() ?? "",
      order: _toInt(json["order"]),
    );
  }
}

class InnerQuizQuestionModel {
  final int id;
  final String body;
  final num marks;
  final int order;
  final List<InnerQuizOptionModel> options;
  final int? selectedOptionId;

  const InnerQuizQuestionModel({
    required this.id,
    required this.body,
    required this.marks,
    required this.order,
    required this.options,
    this.selectedOptionId,
  });

  factory InnerQuizQuestionModel.fromJson(Map<String, dynamic> json) {
    final optionsJson = json["options"] as List<dynamic>? ?? [];
    return InnerQuizQuestionModel(
      id: _toInt(json["id"]),
      body: json["body"]?.toString() ?? "",
      marks: _toNum(json["marks"]),
      order: _toInt(json["order"]),
      options: optionsJson
          .map((e) => InnerQuizOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedOptionId: _toIntOrNull(json["selected_option_id"]),
    );
  }

  InnerQuizQuestionModel copyWith({int? selectedOptionId}) {
    return InnerQuizQuestionModel(
      id: id,
      body: body,
      marks: marks,
      order: order,
      options: options,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
    );
  }
}

class InnerQuizStartModel {
  final int attemptId;
  final int remainingSeconds;
  final List<InnerQuizQuestionModel> questions;

  const InnerQuizStartModel({
    required this.attemptId,
    required this.remainingSeconds,
    required this.questions,
  });

  factory InnerQuizStartModel.fromJson(Map<String, dynamic> json) {
    final questionsJson = json["questions"] as List<dynamic>? ?? [];
    return InnerQuizStartModel(
      attemptId: _toInt(json["attempt_id"]),
      remainingSeconds: _toInt(json["remaining_seconds"]),
      questions: questionsJson
          .map(
            (e) => InnerQuizQuestionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

int _toInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? "") ?? 0;
int? _toIntOrNull(dynamic v) => v == null ? null : _toInt(v);
num _toNum(dynamic v) {
  if (v is num) return v;
  return num.tryParse(v?.toString() ?? "") ?? 0;
}
class InnerQuizSubmitResultModel {
  final String message;
  final num? score;
  final num? percentage;

  const InnerQuizSubmitResultModel({
    required this.message,
    this.score,
    this.percentage,
  });

  factory InnerQuizSubmitResultModel.fromJson(Map<String, dynamic> json) {
    return InnerQuizSubmitResultModel(
      message: json["message"]?.toString() ?? "",
      score: _toNumOrNull(json["score"]),
      percentage: _toNumOrNull(json["percentage"]),
    );
  }
}

num? _toNumOrNull(dynamic v) {
  if (v == null) return null;
  return v is num ? v : num.tryParse(v.toString());
}