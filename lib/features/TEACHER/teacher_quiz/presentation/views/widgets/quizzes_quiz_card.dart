import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quizzes_status_badge.dart';
 
class QuizzesQuizCard extends StatelessWidget {
  final QuizItemModel quiz;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const QuizzesQuizCard({
    super.key,
    required this.quiz,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: QuizzesStatusBadge.borderColor(quiz.status).withOpacity(0.5),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onOpen,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        quiz.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ktextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    QuizzesStatusBadge(status: quiz.status),
                  ],
                ),
                if (quiz.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    quiz.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, thickness: 0.8),
                ),

                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.timer_outlined,
                        text: '${quiz.durationMinutes} دقيقة',
                        color: kDarkPrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.help_outline,
                        text: '${quiz.questionsCount} أسئلة',
                        color: kprimeryColor,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.calendar_today_outlined,
                        text: quiz.startsAt.split(' ').first,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    const Icon(
                      Icons.group_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: quiz.sections.map((sec) {
                            return Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: klightPrimeryColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: kprimeryColor.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                sec['name'] ?? '---',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: kDarkPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit();
                        } else if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        if (quiz.status == QuizStatus.draft)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: kprimeryColor,
                                ),
                                SizedBox(width: 10),
                                Text('تعديل الكويز'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: kRedColor,
                              ),
                              SizedBox(width: 10),
                              Text('حذف', style: TextStyle(color: kRedColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ktextColor.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}