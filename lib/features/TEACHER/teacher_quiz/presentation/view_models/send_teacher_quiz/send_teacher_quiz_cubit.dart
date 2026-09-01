import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/send_quiz_model/send_quiz_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/teacher_quiz_repo.dart';

part 'send_teacher_quiz_state.dart';

class SendTeacherQuizCubit extends Cubit<SendTeacherQuizState> {
  SendTeacherQuizCubit(this.repo) : super(SendTeacherQuizInitial());
  final TeacherQuizzesDetailsRepo repo;

  Future<void> sendTeacherQuiz({required Map<String, dynamic> quizData}) async {
    emit(SendTeacherQuizLoading());
    try {
      final response = await repo.sendTeacherQuizzes(quizData: quizData);

      response.fold(
        (failure) {
          debugPrint('❌ فشل إرسال الكويز: ${failure.errMassage}');
          emit(SendTeacherQuizFailure(failure.errMassage));
        },
        (result) {
          emit(SendTeacherQuizSuccess(sendQuiz: result));
        },
      );
    } catch (e) {
      emit(SendTeacherQuizFailure(e.toString()));
    }
  }

  /// تعديل كويز معلق موجود
  Future<void> updateTeacherQuiz({
    required int quizId,
    required Map<String, dynamic> quizData,
  }) async {
    emit(SendTeacherQuizLoading());
    try {
      final response = await repo.updateTeacherQuiz(
        quizId: quizId,
        quizData: quizData,
      );
      response.fold(
        (failure) {
          debugPrint('❌ فشل تعديل الكويز: ${failure.errMassage}');
          emit(SendTeacherQuizFailure(failure.errMassage));
        },
        (result) {
          emit(SendTeacherQuizSuccess(sendQuiz: result));
        },
      );
    } catch (e) {
      emit(SendTeacherQuizFailure(e.toString()));
    }
  }
}
