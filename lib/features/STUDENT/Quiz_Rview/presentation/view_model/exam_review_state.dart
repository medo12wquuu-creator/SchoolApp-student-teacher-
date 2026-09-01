import 'package:equatable/equatable.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/data/model/exam_review_model.dart';

class ExamReviewState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final ExamReviewResultModel? result;

  const ExamReviewState({
    this.isLoading = false,
    this.errorMessage,
    this.result,
  });

  ExamReviewState copyWith({
    bool? isLoading,
    String? errorMessage,
    ExamReviewResultModel? result,
  }) {
    return ExamReviewState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, result];
}
