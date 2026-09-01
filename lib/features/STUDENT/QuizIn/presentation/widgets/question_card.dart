import 'package:flutter/material.dart';
import 'package:schooly/features/STUDENT/QuizIn/data/models/inner_quiz_model.dart';
import 'question_header.dart';
import 'question_text.dart';
import 'option_item.dart';

class QuestionCard extends StatelessWidget {
  final InnerQuizQuestionModel question;
  final int total;
  final void Function(int optionId) onOptionSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.total,
    required this.onOptionSelected,
  });

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
            QuestionHeader(
              order: question.order,
              total: total,
              marks: question.marks,
            ),
            const SizedBox(height: 14),
            QuestionText(body: question.body),
            const SizedBox(height: 16),
            ...question.options.map(
              (option) => OptionItem(
                body: option.body,
                isSelected: question.selectedOptionId == option.id,
                onTap: () => onOptionSelected(option.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
