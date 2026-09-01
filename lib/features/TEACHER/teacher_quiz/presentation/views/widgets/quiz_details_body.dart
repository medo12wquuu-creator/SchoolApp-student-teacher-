import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quiz_details_card.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quiz_details_row.dart';

class QuizDetailsBody extends StatelessWidget {
  final QuizItemModel quiz;

  const QuizDetailsBody({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        QuizDetailsCard(
          icon: Icons.assignment_outlined,
          title: quiz.title,
          children: [
            if (quiz.description.isNotEmpty)
              QuizDetailsRow(
                icon: Icons.description_outlined,
                text: quiz.description,
              ),
            QuizDetailsRow(
              icon: Icons.timer_outlined,
              text: 'المدة: ${quiz.durationMinutes} دقيقة',
            ),
            QuizDetailsRow(
              icon: Icons.play_circle_outline,
              text: 'البداية: ${quiz.startsAt}',
            ),
            QuizDetailsRow(
              icon: Icons.stop_circle_outlined,
              text: 'النهاية: ${quiz.endsAt}',
            ),
          ],
        ),
        const SizedBox(height: 16),

        QuizDetailsCard(
          icon: Icons.group_outlined,
          title: 'الشعب الموجه لها الاختبار',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: quiz.sections.map((sec) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: klightPrimeryColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kprimeryColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    sec['name'] ?? '---',
                    style: const TextStyle(
                      color: kDarkPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        QuizDetailsCard(
          icon: Icons.help_outline,
          title: 'الأسئلة (${quiz.questionsCount})',
          children: [
            ...quiz.questions.asMap().entries.map((entry) {
              final q = entry.value;
              final options = (q['options'] as List?) ?? const [];
              return _buildQuestionItem(entry.key, q, options);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionItem(int index, dynamic q, List<dynamic> options) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'س${index + 1}: ${q['body']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: ktextColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: klightPrimeryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${q['marks']} درجات',
                  style: const TextStyle(
                    fontSize: 11,
                    color: kprimeryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...options.map((o) {
            final isCorrect = o['is_correct'] == true || o['is_correct'] == 1;
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isCorrect
                    ? kadditionalColor.withOpacity(0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isCorrect
                    ? Border.all(color: kadditionalColor.withOpacity(0.4))
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: isCorrect ? kadditionalColor : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      o['body'] ?? '',
                      style: TextStyle(
                        color: isCorrect ? kadditionalColor : ktextColor,
                        fontWeight: isCorrect
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
