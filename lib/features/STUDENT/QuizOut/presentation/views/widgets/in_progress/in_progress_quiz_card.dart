import 'package:flutter/material.dart';
import 'package:schooly/features/STUDENT/QuizOut/data/model/out_quiz_model.dart';
import 'in_progress_header.dart';
import 'in_progress_countdown.dart';
import 'in_progress_statistics.dart';
import 'in_progress_action_button.dart';

class InProgressQuizCard extends StatelessWidget {
  final OutQuizModel quiz;
  final VoidCallback? onContinue;

  const InProgressQuizCard({super.key, required this.quiz, this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InProgressHeader(
              subject: quiz.subjectName,
              teacher: quiz.teacherName,
            ),
            const SizedBox(height: 16),
            Text(
              quiz.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              quiz.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            InProgressCountdown(seconds: quiz.remainingSeconds ?? 0),
            const SizedBox(height: 16),
            InProgressStatistics(
              questions: quiz.questionsCount,
              totalMarks: quiz.totalMarks,
              minutes: quiz.durationMinutes,
            ),
            const SizedBox(height: 16),
            InProgressActionButton(onPressed: onContinue),
          ],
        ),
      ),
    );
  }
}
