// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../student_user/presentation/view_models/user_cubit.dart';
// import '../../data/repository/inner_quiz_repository.dart';
// import 'inner_quiz_state.dart';

// class InnerQuizCubit extends Cubit<InnerQuizState> {
//   final InnerQuizRepository repo;
//   final UserCubit userCubit;
//   final int examId;

//   InnerQuizCubit(this.repo, this.userCubit, this.examId)
//     : super(const InnerQuizState());

//   Future<void> startExam() async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));

//     try {
//       final token = userCubit.token ?? '';
//       final data = await repo.startExam(token, examId);
//       emit(
//         state.copyWith(
//           isLoading: false,
//           attemptId: data.attemptId,
//           remainingSeconds: data.remainingSeconds,
//           questions: data.questions,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
//     }
//   }

//   /// إجابة واحدة فقط لكل سؤال - يمكن تغييرها لاحقاً
//   Future<void> selectAnswer({
//     required int questionId,
//     required int optionId,
//   }) async {
//     final attemptId = state.attemptId;
//     if (attemptId == null) return;

//     // تحديث محلي فوري (Optimistic UI)
//     final updatedQuestions = state.questions.map((q) {
//       if (q.id == questionId) {
//         return q.copyWith(selectedOptionId: optionId);
//       }
//       return q;
//     }).toList();

//     final updatedSubmitting = Set<int>.from(state.submittingQuestionIds)
//       ..add(questionId);

//     emit(
//       state.copyWith(
//         questions: updatedQuestions,
//         submittingQuestionIds: updatedSubmitting,
//       ),
//     );

//     try {
//       final token = userCubit.token ?? '';
//       await repo.submitAnswer(
//         token: token,
//         attemptId: attemptId,
//         questionId: questionId,
//         optionId: optionId,
//       );
//     } catch (_) {
//       // ممكن هون تعرض SnackBar بخطأ الرفع بدون فقدان الاختيار المحلي
//     } finally {
//       final finishedSubmitting = Set<int>.from(state.submittingQuestionIds)
//         ..remove(questionId);
//       emit(state.copyWith(submittingQuestionIds: finishedSubmitting));
//     }
//   }
// }
///////////////////////////
library;

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:schooly/features/STUDENT/QuizIn/data/models/inner_quiz_model.dart';
// import '../../../student_user/presentation/view_models/user_cubit.dart';
// import '../../data/repository/inner_quiz_repository.dart';
// import 'inner_quiz_state.dart';

// class InnerQuizCubit extends Cubit<InnerQuizState> {
//   final InnerQuizRepository repo;
//   final UserCubit userCubit;
//   final int examId;

//   InnerQuizCubit(this.repo, this.userCubit, this.examId)
//     : super(const InnerQuizState());

//   Future<void> startExam() async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));

//     try {
//       final token = userCubit.token ?? '';
//       final data = await repo.startExam(token, examId);

//       if (isClosed) return;

//       emit(
//         state.copyWith(
//           isLoading: false,
//           attemptId: data.attemptId,
//           remainingSeconds: data.remainingSeconds,
//           questions: data.questions,
//         ),
//       );
//     } catch (e) {
//       if (isClosed) return;
//       emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
//     }
//   }

//   /// إجابة واحدة فقط لكل سؤال - يمكن تغييرها لاحقاً
//   Future<void> selectAnswer({
//     required int questionId,
//     required int optionId,
//   }) async {
//     final attemptId = state.attemptId;
//     if (attemptId == null) return;

//     final updatedQuestions = state.questions.map((InnerQuizQuestionModel q) {
//       if (q.id == questionId) {
//         return q.copyWith(selectedOptionId: optionId);
//       }
//       return q;
//     }).toList();

//     final updatedSubmitting = Set<int>.from(state.submittingQuestionIds)
//       ..add(questionId);

//     if (isClosed) return;
//     emit(
//       state.copyWith(
//         questions: updatedQuestions,
//         submittingQuestionIds: updatedSubmitting,
//       ),
//     );

//     try {
//       final token = userCubit.token ?? '';
//       await repo.submitAnswer(
//         token: token,
//         attemptId: attemptId,
//         questionId: questionId,
//         optionId: optionId,
//       );
//     } catch (_) {
//       // ممكن هون تعرض SnackBar بخطأ الرفع بدون فقدان الاختيار المحلي
//     } finally {
//       if (!isClosed) {
//         final finishedSubmitting = Set<int>.from(state.submittingQuestionIds)
//           ..remove(questionId);
//         emit(state.copyWith(submittingQuestionIds: finishedSubmitting));
//       }
//     }
//   }

//   /// تسليم الاختبار نهائياً
//   Future<InnerQuizSubmitResultModel?> submitExam() async {
//     final attemptId = state.attemptId;
//     if (attemptId == null) return null;

//     if (!isClosed) emit(state.copyWith(isSubmitting: true));

//     try {
//       final token = userCubit.token ?? '';
//       final result = await repo.submitExam(token: token, attemptId: attemptId);

//       if (!isClosed) emit(state.copyWith(isSubmitting: false));
//       return result;
//     } catch (e) {
//       if (!isClosed) {
//         emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
//       }
//       return null;
//     }
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/services/reverb_service.dart';
import 'package:schooly/features/STUDENT/QuizIn/data/models/inner_quiz_model.dart';
import '../../../student_user/presentation/view_models/user_cubit.dart';
import '../../data/repository/inner_quiz_repository.dart';
import 'inner_quiz_state.dart';

class InnerQuizCubit extends Cubit<InnerQuizState> {
  final InnerQuizRepository repo;
  final UserCubit userCubit;
  final int examId;
  final ReverbService reverb;

  InnerQuizCubit(this.repo, this.userCubit, this.examId, this.reverb)
    : super(const InnerQuizState());

  Future<void> startExam() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final token = userCubit.token ?? '';
      final data = await repo.startExam(token, examId);

      if (isClosed) return;

      emit(
        state.copyWith(
          isLoading: false,
          attemptId: data.attemptId,
          remainingSeconds: data.remainingSeconds,
          questions: data.questions,
        ),
      );

      _listenToQuizChannel();
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// إجابة واحدة فقط لكل سؤال - يمكن تغييرها لاحقاً
  Future<void> selectAnswer({
    required int questionId,
    required int optionId,
  }) async {
    final attemptId = state.attemptId;
    if (attemptId == null) return;

    final updatedQuestions = state.questions.map((InnerQuizQuestionModel q) {
      if (q.id == questionId) {
        return q.copyWith(selectedOptionId: optionId);
      }
      return q;
    }).toList();

    final updatedSubmitting = Set<int>.from(state.submittingQuestionIds)
      ..add(questionId);

    if (isClosed) return;
    emit(
      state.copyWith(
        questions: updatedQuestions,
        submittingQuestionIds: updatedSubmitting,
      ),
    );

    try {
      final token = userCubit.token ?? '';
      await repo.submitAnswer(
        token: token,
        attemptId: attemptId,
        questionId: questionId,
        optionId: optionId,
      );
    } catch (_) {
      // ممكن هون تعرض SnackBar بخطأ الرفع بدون فقدان الاختيار المحلي
    } finally {
      if (!isClosed) {
        final finishedSubmitting = Set<int>.from(state.submittingQuestionIds)
          ..remove(questionId);
        emit(state.copyWith(submittingQuestionIds: finishedSubmitting));
      }
    }
  }

  /// تسليم الاختبار نهائياً
  Future<InnerQuizSubmitResultModel?> submitExam() async {
    final attemptId = state.attemptId;
    if (attemptId == null) return null;

    if (!isClosed) emit(state.copyWith(isSubmitting: true));

    try {
      final token = userCubit.token ?? '';
      final result = await repo.submitExam(token: token, attemptId: attemptId);

      if (!isClosed) {
        emit(state.copyWith(isSubmitting: false, isEnded: true));
      }
      return result;
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
      }
      return null;
    }
  }

  /// استماع على نفس قناة الكويزات أثناء الاختبار
  void _listenToQuizChannel() {
    final userId = userCubit.currentUser?.id ?? 0;
    if (userId == 0) return;

    reverb.listenToExams(
      userId: userId,
      onExamPublished: (_) {},
      onExamClosed: (json) => _handleExamClosed(json),
      onExamTimeEnded: (json) => _handleTimeEnded(json),
      onExamResultReady: (_) {},
      onExamCompleted: (_) {},
      onExamAvailable: (_) {},
    );
  }

  int? _eventExamId(Map<String, dynamic> json) {
    final v = json['exam_id'];
    return v == null ? null : _toInt(v);
  }

  void _handleExamClosed(Map<String, dynamic> json) {
    if (isClosed) return;
    if (_eventExamId(json) != examId) return;

    emit(
      state.copyWith(isEnded: true, closedByTeacher: true, remainingSeconds: 0),
    );
  }

  void _handleTimeEnded(Map<String, dynamic> json) {
    if (isClosed) return;
    if (_eventExamId(json) != examId) return;

    emit(state.copyWith(isEnded: true, remainingSeconds: 0));
  }

  /// عند انتهاء العداد المحلي (fallback إذا لم يصل حدث time_ended)
  void onQuizEndedLocally() {
    emit(state.copyWith(isEnded: true, remainingSeconds: 0));
  }
}

int _toInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? "") ?? 0;
