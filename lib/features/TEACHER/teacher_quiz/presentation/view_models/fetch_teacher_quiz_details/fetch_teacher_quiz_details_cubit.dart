import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/teacher_quiz_repo.dart';

part 'fetch_teacher_quiz_details_state.dart';

class FetchTeacherQuizDetailsCubit extends Cubit<FetchTeacherQuizDetailsState> {
  FetchTeacherQuizDetailsCubit(this.repo)
    : super(FetchTeacherQuizDetailsInitial());
  final TeacherQuizzesDetailsRepo repo;

  /// جلب تفاصيل كويز محدّد من الباك إيند
  Future<void> fetchQuizDetails(int quizId) async {
    emit(FetchTeacherQuizDetailsLoading());
    try {
      final response = await repo.fetchTeacherQuizDetails(quizId: quizId);
      response.fold(
        (failure) => emit(FetchTeacherQuizDetailsFailure(failure.errMassage)),
        (result) {
          final quiz = result.data == null
              ? null
              : QuizItemModel.fromData(result.data!);
          if (quiz == null) {
            emit(
              const FetchTeacherQuizDetailsFailure(
                'لا توجد بيانات لهذا الكويز',
              ),
            );
            return;
          }
          emit(FetchTeacherQuizDetailsSuccess(quiz: quiz));
        },
      );
    } catch (e) {
      emit(FetchTeacherQuizDetailsFailure(e.toString()));
    }
  }
}
