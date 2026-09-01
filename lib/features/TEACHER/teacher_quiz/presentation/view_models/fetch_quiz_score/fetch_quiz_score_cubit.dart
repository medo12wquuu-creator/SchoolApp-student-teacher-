import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/fetch_quiz_score_model/fetch_quiz_score_model.dart';

import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/teacher_quiz_repo.dart';

part 'fetch_quiz_score_state.dart';

class FetchQuizScoreCubit extends Cubit<FetchQuizScoreState> {
  FetchQuizScoreCubit(this.repo) : super(FetchQuizScoreInitial());
  final TeacherQuizzesDetailsRepo repo;

  /// جلب علامات الطلاب لكويز مغلق من الباك إيند
  Future<void> fetchQuizScore(int quizId) async {
    emit(FetchQuizScoreLoading());
    try {
      final response = await repo.fetchQuizScore(quizId: quizId);
      response.fold(
        (failure) => emit(
          FetchQuizScoreFailure(
            failure.errMassage,
            debugDetails: failure.debugDetails,
          ),
        ),
        // (result) => emit(FetchQuizScoreSuccess(quizScore: result)),
        (result) {
          debugPrint('📊 RAW SECTIONS: ${result.sections}');
          if (result.sections != null && result.sections!.isNotEmpty) {
            final first = result.sections!.first;
            if (first.students != null && first.students!.isNotEmpty) {
              debugPrint(
                '📊 FIRST STUDENT RAW JSON KEYS: ${first.students!.first.toJson()}',
              );
            }
          }
          emit(FetchQuizScoreSuccess(quizScore: result));
        },
      );
    } catch (e) {
      debugPrint('🔴 النتائج: خطأ غير متوقع $e');
      emit(FetchQuizScoreFailure(e.toString()));
    }
  }
}
