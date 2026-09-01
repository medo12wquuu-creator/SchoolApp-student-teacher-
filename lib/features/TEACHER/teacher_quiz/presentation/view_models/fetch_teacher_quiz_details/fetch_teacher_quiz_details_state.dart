part of 'fetch_teacher_quiz_details_cubit.dart';

@immutable
abstract class FetchTeacherQuizDetailsState {
  const FetchTeacherQuizDetailsState();
}

final class FetchTeacherQuizDetailsInitial
    extends FetchTeacherQuizDetailsState {
  const FetchTeacherQuizDetailsInitial();
}

final class FetchTeacherQuizDetailsLoading
    extends FetchTeacherQuizDetailsState {
  const FetchTeacherQuizDetailsLoading();
}

final class FetchTeacherQuizDetailsSuccess
    extends FetchTeacherQuizDetailsState {
  final QuizItemModel quiz;

  const FetchTeacherQuizDetailsSuccess({required this.quiz});
}

final class FetchTeacherQuizDetailsFailure
    extends FetchTeacherQuizDetailsState {
  final String message;

  const FetchTeacherQuizDetailsFailure(this.message);
}
