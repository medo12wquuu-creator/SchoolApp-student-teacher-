import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quizzes_quiz_card.dart';
 
class QuizzesQuizListView extends StatelessWidget {
  final List<QuizItemModel> quizzes;
  final ValueChanged<QuizItemModel> onOpen;
  final ValueChanged<QuizItemModel> onEdit;
  final ValueChanged<QuizItemModel> onDelete;

  const QuizzesQuizListView({
    super.key,
    required this.quizzes,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'لا يوجد كويزات متاحة حالياً',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return QuizzesQuizCard(
          quiz: quiz,
          onOpen: () => onOpen(quiz),
          onEdit: () => onEdit(quiz),
          onDelete: () => onDelete(quiz),
        );
      },
    );
  }
}