import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/teacher_quiz_repo.dart';

part 'fetch_teacher_quizzes_state.dart';

class FetchTeacherQuizzesCubit extends Cubit<FetchTeacherQuizzesState> {
  FetchTeacherQuizzesCubit(this.repo) : super(FetchTeacherQuizzesInitial());
  final TeacherQuizzesDetailsRepo repo;

  /// جلب قائمة الكويزات من الباك إيند
  Future<void> fetchQuizzes() async {
    if (state is! FetchTeacherQuizzesLoading) {
      emit(FetchTeacherQuizzesLoading());
    }
    try {
      final response = await repo.fetchTeacherQuizzes();
      response.fold(
        (failure) => emit(FetchTeacherQuizzesFailure(failure.errMassage)),
        (result) {
          final quizzes = (result.data ?? const [])
              .map(QuizItemModel.fromDatum)
              .toList();
          emit(FetchTeacherQuizzesSuccess(quizzes: quizzes));
        },
      );
    } catch (e) {
      emit(FetchTeacherQuizzesFailure(e.toString()));
    }
  }

  /// نشر كويز معلق (تحويله إلى مرسل)
  Future<bool> publishQuiz(int quizId) async {
    try {
      final response = await repo.publishTeacherQuiz(quizId: quizId);
      var success = false;
      response.fold<void>(
        (failure) => debugPrint('❌ فشل نشر الكويز: ${failure.errMassage}'),
        (_) => success = true,
      );
      if (success) await fetchQuizzes();
      return success;
    } catch (e) {
      debugPrint('❌ فشل نشر الكويز: $e');
      return false;
    }
  }

  /// تحديث حالة كويز محدد إلى مغلق في القائمة (بعد حدث exam.time_ended)
  void markQuizClosed(int quizId) {
    final current = state;
    if (current is! FetchTeacherQuizzesSuccess) return;

    final updated = current.quizzes.map((quiz) {
      if (quiz.id == '$quizId' &&
          quiz.status != QuizStatus.closed) {
        quiz.status = QuizStatus.closed;
      }
      return quiz;
    }).toList();

    emit(FetchTeacherQuizzesSuccess(quizzes: updated));
  }

  /// حذف كويز من الباك إيند
  Future<bool> deleteQuiz(int quizId) async {
    try {
      final response = await repo.deleteTeacherQuiz(quizId: quizId);
      var success = false;
      response.fold<void>(
        (failure) => debugPrint('❌ فشل حذف الكويز: ${failure.errMassage}'),
        (_) => success = true,
      );
      if (success) await fetchQuizzes();
      return success;
    } catch (e) {
      debugPrint('❌ فشل حذف الكويز: $e');
      return false;
    }
  }
}
