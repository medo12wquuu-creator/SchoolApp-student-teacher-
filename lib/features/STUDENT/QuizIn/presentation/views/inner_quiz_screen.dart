import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/services/reverb_service.dart';
import 'package:schooly/features/STUDENT/QuizIn/data/datasource/inner_quiz_remote_data_source.dart';
import 'package:schooly/features/STUDENT/QuizIn/data/repository/inner_quiz_repository.dart';
import 'package:schooly/features/STUDENT/QuizIn/presentation/view_model/inner_quiz_cubit.dart';
import 'package:schooly/features/STUDENT/QuizIn/presentation/view_model/inner_quiz_state.dart';
import 'package:schooly/features/STUDENT/QuizIn/presentation/widgets/question_card.dart';
import 'package:schooly/features/STUDENT/QuizIn/presentation/widgets/quiz_app_bar.dart';
import 'package:schooly/features/STUDENT/QuizIn/presentation/widgets/upload_answers_button.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';

class InnerQuizScreen extends StatelessWidget {
  final int examId;
  final String examTitle;

  const InnerQuizScreen({
    super.key,
    required this.examId,
    required this.examTitle,
  });

  Future<void> _handleSubmit(BuildContext context) async {
    final cubit = context.read<InnerQuizCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            'تسليم الاختبار',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'هل أنت متأكد أنك تريد تسليم الاختبار؟ لا يمكنك التراجع بعد التسليم.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('موافق', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final result = await cubit.submitExam();

    if (!context.mounted) return;
    if (result == null) return;

    // نتيجة التسليم تظهر داخل نفس الشاشة — بدون خروج وعودة
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            'تم التسليم',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            result.score == null
                ? 'ستظهر النتيجة بعد النتهاء الامتحان'
                : '${result.message}\n'
                      'النتيجة: ${result.score}'
                      '${result.percentage != null ? ' (${result.percentage!.toStringAsFixed(0)}%)' : ''}',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(
                  context,
                ); // بلا نتيجة → القائمة تتحدث من الـ WS/getExams
              },
              child: const Text('حسناً', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final userCubit = context.read<UserCubit>();
        final token = userCubit.token ?? '';
        return InnerQuizCubit(
          InnerQuizRepository(InnerQuizRemoteDataSource(Dio())),
          userCubit,
          examId,
          ReverbService(
            appKey: "suph6ug028gzlw8wdwib",
            wssHost: ApiConstants.wss,
            httpHost: "https://diving-settle-careless.ngrok-free.dev",
            token: token,
          ),
        )..startExam();
      },
      child: Builder(
        builder: (context) {
          return BlocListener<InnerQuizCubit, InnerQuizState>(
            listenWhen: (previous, current) =>
                !previous.closedByTeacher && current.closedByTeacher,
            listener: (context, state) {
              // الأستاذ أغلق الكويز → الشاشة تنقفل فوراً (متطلب الباك)
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF7F9FC),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight + 1),
                child: BlocBuilder<InnerQuizCubit, InnerQuizState>(
                  builder: (context, state) {
                    return QuizAppBar(
                      title: examTitle,
                      remainingSeconds: state.remainingSeconds,
                      onTimeExpired: () {
                        context.read<InnerQuizCubit>().onQuizEndedLocally();
                      },
                    );
                  },
                ),
              ),
              body: BlocBuilder<InnerQuizCubit, InnerQuizState>(
                builder: (context, state) {
                  if (state.isLoading && state.questions.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.errorMessage != null && state.questions.isEmpty) {
                    return Center(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state.questions.isEmpty) {
                    return const Center(child: Text('لا توجد أسئلة'));
                  }

                  final cubit = context.read<InnerQuizCubit>();

                  return Column(
                    children: [
                      if (state.isEnded)
                        _buildEndedBanner(state.closedByTeacher),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.questions.length,
                          itemBuilder: (context, index) {
                            final question = state.questions[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: QuestionCard(
                                question: question,
                                total: state.questions.length,
                                onOptionSelected: state.isEnded
                                    ? (_) {} // الكويز انتهى → الإجابات معطّلة
                                    : (optionId) {
                                        cubit.selectAnswer(
                                          questionId: question.id,
                                          optionId: optionId,
                                        );
                                      },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: state.isEnded
                            ? SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'العودة للقائمة',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : UploadAnswersButton(
                                isLoading: state.isSubmitting,
                                onPressed: () => _handleSubmit(context),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEndedBanner(bool closedByTeacher) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: closedByTeacher
            ? const Color(0xFFFFEBEE)
            : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            closedByTeacher ? Icons.lock_outline : Icons.timer_off_outlined,
            size: 20,
            color: closedByTeacher
                ? const Color(0xFFD32F2F)
                : const Color(0xFFF57F17),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              closedByTeacher
                  ? 'تم إغلاق الاختبار من قبل الأستاذ'
                  : 'انتهى وقت الاختبار',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: closedByTeacher
                    ? const Color(0xFFD32F2F)
                    : const Color(0xFFF57F17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
