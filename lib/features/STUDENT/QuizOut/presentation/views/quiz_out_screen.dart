import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/services/reverb_service.dart';
import 'package:schooly/features/STUDENT/QuizOut/data/datasource/out_quiz_remote_data_source.dart';
import 'package:schooly/features/STUDENT/QuizOut/data/model/out_quiz_model.dart';
import 'package:schooly/features/STUDENT/QuizOut/data/repository/out_quiz_repository.dart';
import 'package:schooly/features/STUDENT/QuizOut/presentation/view_model/out_quiz_cubit.dart';
import 'package:schooly/features/STUDENT/QuizOut/presentation/view_model/out_quiz_state.dart';
import 'package:schooly/features/STUDENT/QuizOut/presentation/views/widgets/available/available_quiz_card.dart';
import 'package:schooly/features/STUDENT/QuizOut/presentation/views/widgets/completed/completed_quiz_card.dart';
import 'package:schooly/features/STUDENT/QuizOut/presentation/views/widgets/in_progress/in_progress_quiz_card.dart';
import 'package:schooly/features/STUDENT/QuizOut/presentation/views/widgets/missed/missed_quiz_card.dart';
import 'package:schooly/features/STUDENT/QuizOut/presentation/views/widgets/upcoming/upcoming_quiz_card.dart';
import 'package:schooly/features/STUDENT/QuizIn/presentation/views/inner_quiz_screen.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';

class QuizOutScreen extends StatelessWidget {
  const QuizOutScreen({super.key});

  void _showSubmitResultDialog(
    BuildContext context,
    Map<String, dynamic> result,
  ) {
    final message = result['message'] as String?;
    final score = result['score'] as num?;
    final percentage = result['percentage'] as num?;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text('تم التسليم', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message ?? ''),
              if (score != null) ...[
                const SizedBox(height: 10),
                Text(
                  'النتيجة: $score'
                  '${percentage != null ? ' (${percentage.toStringAsFixed(0)}%)' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext),
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
        return OutQuizCubit(
            OutQuizRepository(OutQuizRemoteDataSource(Dio())),
            userCubit,
            ReverbService(
              appKey: "suph6ug028gzlw8wdwib",
              wssHost: ApiConstants.wss,
              httpHost: "https://diving-settle-careless.ngrok-free.dev",
              token: token,
            ),
          )
          ..getExams()
          ..listenToQuizEvents();
      },
      child: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final primary = Theme.of(context).colorScheme.primary;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: isDark ? const Color(0xFF1A1C1E) : Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: primary),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'اختبارات',
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  height: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : const Color(0xFFD8DADD),
                ),
              ),
            ),
            body: BlocBuilder<OutQuizCubit, OutQuizState>(
              builder: (context, state) {
                if (state.isLoading && state.quizzes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.errorMessage != null && state.quizzes.isEmpty) {
                  return Center(
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state.quizzes.isEmpty) {
                  return const Center(child: Text('لا توجد اختبارات'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = state.quizzes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCard(context, quiz),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, OutQuizModel quiz) {
    debugPrint('Quiz ${quiz.id}: status=${quiz.displayStatus}');
    switch (quiz.displayStatus) {
      case 'available':
        return AvailableQuizCard(
          quiz: quiz,
          onStart: () => _openInnerQuiz(context, quiz),
        );
      case 'upcoming':
        return UpcomingQuizCard(quiz: quiz);
      case 'in_progress':
        return InProgressQuizCard(
          quiz: quiz,
          onContinue: () => _openInnerQuiz(context, quiz),
        );
      case 'completed':
        return CompletedQuizCard(quiz: quiz);
      case 'missed':
        return MissedQuizCard(quiz: quiz);
      default:
        return AvailableQuizCard(quiz: quiz);
    }
  }

  Future<void> _openInnerQuiz(BuildContext context, OutQuizModel quiz) async {
    final cubit = context.read<OutQuizCubit>();

    final result = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => InnerQuizScreen(examId: quiz.id, examTitle: quiz.title),
      ),
    );

    if (!context.mounted) return;

    if (result != null) {
      _showSubmitResultDialog(context, result);
    }

    cubit.getExams(); // ✅ القائمة تتحدث دائماً عند الرجوع
  }
}
