import 'package:flutter/material.dart';
import 'package:schooly/features/STUDENT/QuizOut/data/model/out_quiz_model.dart';
import 'completed_header.dart';
import 'completed_score.dart';
import 'completed_statistics.dart';

class CompletedQuizCard extends StatelessWidget {
  final OutQuizModel quiz;

  const CompletedQuizCard({super.key, required this.quiz});

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
            CompletedHeader(
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
            CompletedScore(
              score: quiz.score,
              totalMarks: quiz.totalMarks,
              percentage: quiz.percentage,
              attemptId: quiz.attemptId, // ← جديد
            ),
            const SizedBox(height: 16),
            CompletedStatistics(
              questions: quiz.questionsCount,
              totalMarks: quiz.totalMarks,
              minutes: quiz.durationMinutes,
            ),
          ],
        ),
      ),
    );
  }
}
