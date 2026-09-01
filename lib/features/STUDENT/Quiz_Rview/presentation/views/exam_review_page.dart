import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/data/datasource/exam_review_remote_data_source.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/data/model/exam_review_model.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/data/repository/exam_review_repository.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/presentation/view_model/exam_review_cubit.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/presentation/view_model/exam_review_state.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/presentation/views/widget/answer_card.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/presentation/views/widget/question_card_review.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/presentation/views/widget/result_card.dart';
import 'package:schooly/features/STUDENT/Quiz_Rview/presentation/views/widget/section_title.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';

class ExamReviewPage extends StatelessWidget {
  final int attemptId;

  const ExamReviewPage({super.key, required this.attemptId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExamReviewCubit(
        ExamReviewRepository(ExamReviewRemoteDataSource(Dio())),
        context.read<UserCubit>(),
        attemptId,
      )..getResult(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF172B4D),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'مراجعة الاختبار',
            style: TextStyle(
              color: Color.fromARGB(255, 16, 107, 225),
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: BlocBuilder<ExamReviewCubit, ExamReviewState>(
          builder: (context, state) {
            if (state.isLoading && state.result == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.result == null) {
              return Center(
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final result = state.result;
            if (result == null || result.details.isEmpty) {
              return const Center(child: Text('لا توجد بيانات لعرضها'));
            }

            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResultCard(
                      score: result.score,
                      total: result.total,
                      percentage: result.percentage,
                      status: result.status,
                    ),
                    const SizedBox(height: 30),
                    for (int i = 0; i < result.details.length; i++) ...[
                      _buildQuestionReview(
                        i,
                        result.details.length,
                        result.details[i],
                      ),
                      if (i != result.details.length - 1)
                        const SizedBox(height: 30),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuestionReview(
    int index,
    int total,
    ExamReviewDetailModel detail,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuestionCardReview(
          index: index + 1,
          total: total,
          question: detail.question,
          marks: detail.marks,
        ),
        const SizedBox(height: 20),
        const SectionTitle(title: 'إجابتك'),
        const SizedBox(height: 12),
        AnswerCard(
          label: 'إجابتك',
          answer: detail.selectedOption,
          isCorrect: detail.isCorrect,
          icon: Icons.person_outline_rounded,
        ),
        if (!detail.isCorrect) ...[
          const SizedBox(height: 20),
          const SectionTitle(title: 'الإجابة الصحيحة'),
          const SizedBox(height: 12),
          AnswerCard(
            label: 'الإجابة الصحيحة',
            answer: detail.correctOption,
            isCorrect: true,
            icon: Icons.check_circle_outline_rounded,
          ),
        ],
      ],
    );
  }
}
