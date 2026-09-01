part of 'send_teacher_quiz_cubit.dart';

@immutable
abstract class SendTeacherQuizState {}

class SendTeacherQuizInitial extends SendTeacherQuizState {}

class SendTeacherQuizLoading extends SendTeacherQuizState {}

class SendTeacherQuizSuccess extends SendTeacherQuizState {
  final SendQuizModel sendQuiz;

  SendTeacherQuizSuccess({required this.sendQuiz});
}

class SendTeacherQuizFailure extends SendTeacherQuizState {
  final String errMassage;

  SendTeacherQuizFailure(this.errMassage);
}
