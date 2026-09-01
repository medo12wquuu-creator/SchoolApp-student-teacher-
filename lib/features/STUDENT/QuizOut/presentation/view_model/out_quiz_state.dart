import 'package:equatable/equatable.dart';
import '../../data/model/out_quiz_model.dart';

class OutQuizState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<OutQuizModel> quizzes;

  const OutQuizState({
    this.isLoading = false,
    this.errorMessage,
    this.quizzes = const [],
  });

  OutQuizState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<OutQuizModel>? quizzes,
  }) {
    return OutQuizState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      quizzes: quizzes ?? this.quizzes,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, quizzes];
}
