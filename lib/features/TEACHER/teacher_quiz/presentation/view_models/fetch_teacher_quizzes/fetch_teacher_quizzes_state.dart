part of 'fetch_teacher_quizzes_cubit.dart';

@immutable
abstract class FetchTeacherQuizzesState {
  const FetchTeacherQuizzesState();
}

final class FetchTeacherQuizzesInitial extends FetchTeacherQuizzesState {
  const FetchTeacherQuizzesInitial();
}

final class FetchTeacherQuizzesLoading extends FetchTeacherQuizzesState {
  const FetchTeacherQuizzesLoading();
}

final class FetchTeacherQuizzesSuccess extends FetchTeacherQuizzesState {
  final List<QuizItemModel> quizzes;

  const FetchTeacherQuizzesSuccess({required this.quizzes});
}

final class FetchTeacherQuizzesFailure extends FetchTeacherQuizzesState {
  final String message;

  const FetchTeacherQuizzesFailure(this.message);
}
