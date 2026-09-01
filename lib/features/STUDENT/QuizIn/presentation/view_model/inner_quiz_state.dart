// import 'package:equatable/equatable.dart';
// import 'package:schooly/features/STUDENT/QuizIn/data/models/inner_quiz_model.dart';

// class InnerQuizState extends Equatable {
//   final bool isLoading;
//   final String? errorMessage;
//   final int? attemptId;
//   final int remainingSeconds;
//   final List<InnerQuizQuestionModel> questions;
//   final Set<int> submittingQuestionIds;

//   const InnerQuizState({
//     this.isLoading = false,
//     this.errorMessage,
//     this.attemptId,
//     this.remainingSeconds = 0,
//     this.questions = const [],
//     this.submittingQuestionIds = const {},
//   });

//   InnerQuizState copyWith({
//     bool? isLoading,
//     String? errorMessage,
//     int? attemptId,
//     int? remainingSeconds,
//     List<InnerQuizQuestionModel>? questions,
//     Set<int>? submittingQuestionIds,
//   }) {
//     return InnerQuizState(
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage,
//       attemptId: attemptId ?? this.attemptId,
//       remainingSeconds: remainingSeconds ?? this.remainingSeconds,
//       questions: questions ?? this.questions,
//       submittingQuestionIds:
//           submittingQuestionIds ?? this.submittingQuestionIds,
//     );
//   }

//   int get answeredCount =>
//       questions.where((q) => q.selectedOptionId != null).length;

//   @override
//   List<Object?> get props => [
//     isLoading,
//     errorMessage,
//     attemptId,
//     remainingSeconds,
//     questions,
//     submittingQuestionIds,
//   ];
// }
//////////////////////////////////
library;

// import 'package:equatable/equatable.dart';
// import 'package:schooly/features/STUDENT/QuizIn/data/models/inner_quiz_model.dart';

// class InnerQuizState extends Equatable {
//   final bool isLoading;
//   final bool isSubmitting;
//   final String? errorMessage;
//   final int? attemptId;
//   final int remainingSeconds;
//   final List<InnerQuizQuestionModel> questions;
//   final Set<int> submittingQuestionIds;

//   const InnerQuizState({
//     this.isLoading = false,
//     this.isSubmitting = false,
//     this.errorMessage,
//     this.attemptId,
//     this.remainingSeconds = 0,
//     this.questions = const [],
//     this.submittingQuestionIds = const {},
//   });

//   InnerQuizState copyWith({
//     bool? isLoading,
//     bool? isSubmitting,
//     String? errorMessage,
//     int? attemptId,
//     int? remainingSeconds,
//     List<InnerQuizQuestionModel>? questions,
//     Set<int>? submittingQuestionIds,
//   }) {
//     return InnerQuizState(
//       isLoading: isLoading ?? this.isLoading,
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//       errorMessage: errorMessage,
//       attemptId: attemptId ?? this.attemptId,
//       remainingSeconds: remainingSeconds ?? this.remainingSeconds,
//       questions: questions ?? this.questions,
//       submittingQuestionIds:
//           submittingQuestionIds ?? this.submittingQuestionIds,
//     );
//   }

//   int get answeredCount => questions
//       .where((InnerQuizQuestionModel q) => q.selectedOptionId != null)
//       .length;

//   @override
//   List<Object?> get props => [
//     isLoading,
//     isSubmitting,
//     errorMessage,
//     attemptId,
//     remainingSeconds,
//     questions,
//     submittingQuestionIds,
//   ];
// }
import 'package:equatable/equatable.dart';
import 'package:schooly/features/STUDENT/QuizIn/data/models/inner_quiz_model.dart';

class InnerQuizState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final int? attemptId;
  final int remainingSeconds;
  final List<InnerQuizQuestionModel> questions;
  final Set<int> submittingQuestionIds;
  final bool isEnded; // ← جديد
  final bool closedByTeacher; // ← جديد

  const InnerQuizState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.attemptId,
    this.remainingSeconds = 0,
    this.questions = const [],
    this.submittingQuestionIds = const {},
    this.isEnded = false,
    this.closedByTeacher = false,
  });

  InnerQuizState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    int? attemptId,
    int? remainingSeconds,
    List<InnerQuizQuestionModel>? questions,
    Set<int>? submittingQuestionIds,
    bool? isEnded,
    bool? closedByTeacher,
  }) {
    return InnerQuizState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      attemptId: attemptId ?? this.attemptId,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      questions: questions ?? this.questions,
      submittingQuestionIds:
          submittingQuestionIds ?? this.submittingQuestionIds,
      isEnded: isEnded ?? this.isEnded,
      closedByTeacher: closedByTeacher ?? this.closedByTeacher,
    );
  }

  int get answeredCount => questions
      .where((InnerQuizQuestionModel q) => q.selectedOptionId != null)
      .length;

  @override
  List<Object?> get props => [
    isLoading,
    isSubmitting,
    errorMessage,
    attemptId,
    remainingSeconds,
    questions,
    submittingQuestionIds,
    isEnded,
    closedByTeacher,
  ];
}
