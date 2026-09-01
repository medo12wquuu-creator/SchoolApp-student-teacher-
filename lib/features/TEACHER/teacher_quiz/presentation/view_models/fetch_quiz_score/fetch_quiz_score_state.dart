part of 'fetch_quiz_score_cubit.dart';

@immutable
abstract class FetchQuizScoreState {
  const FetchQuizScoreState();
}

final class FetchQuizScoreInitial extends FetchQuizScoreState {
  const FetchQuizScoreInitial();
}

final class FetchQuizScoreLoading extends FetchQuizScoreState {
  const FetchQuizScoreLoading();
}

final class FetchQuizScoreSuccess extends FetchQuizScoreState {
  final FetchQuizScoreModel quizScore;

  const FetchQuizScoreSuccess({required this.quizScore});
}

final class FetchQuizScoreFailure extends FetchQuizScoreState {
  final String message;
  final String? debugDetails;

  const FetchQuizScoreFailure(this.message, {this.debugDetails});
}