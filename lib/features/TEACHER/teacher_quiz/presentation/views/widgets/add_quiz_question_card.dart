import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/add_quiz_text_field.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quiz_form_models.dart';
 
class AddQuizQuestionCard extends StatefulWidget {
  final int index;
  final QuestionModel question;
  final VoidCallback onRemoveQuestion;
  final VoidCallback onChanged;

  const AddQuizQuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.onRemoveQuestion,
    required this.onChanged,
  });

  @override
  State<AddQuizQuestionCard> createState() => _AddQuizQuestionCardState();
}

class _AddQuizQuestionCardState extends State<AddQuizQuestionCard> {
  void _toggleCorrect(int optIndex) {
    for (var opt in widget.question.options) {
      opt.isCorrect = false;
    }
    widget.question.options[optIndex].isCorrect = true;
    widget.onChanged();
  }

  void _removeOption(int optIndex) {
    widget.question.options.removeAt(optIndex);
    widget.onChanged();
  }

  void _addOption() {
    widget.question.options.add(OptionModel());
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'السؤال ${widget.index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kDarkPrimaryColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: kRedColor),
                  onPressed: widget.onRemoveQuestion,
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AddQuizTextField(
                    controller: question.bodyController,
                    label: 'نص السؤال',
                    icon: Icons.help_outline,
                    validator: (v) => v!.isEmpty ? 'أدخل نص السؤال' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: AddQuizTextField(
                    controller: question.marksController,
                    label: 'الدرجة',
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'الدرجة' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'الخيارات / الإجابات:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: ktextColor,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(question.options.length, (optIndex) {
              final option = question.options[optIndex];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: option.isCorrect
                      ? klightAdditionalColor
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: option.isCorrect
                        ? kadditionalColor
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        option.isCorrect
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: option.isCorrect ? kadditionalColor : Colors.grey,
                      ),
                      onPressed: () => _toggleCorrect(optIndex),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: option.controller,
                        decoration: InputDecoration(
                          hintText: 'إجابة ${optIndex + 1}',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        validator: (v) => v!.isEmpty ? 'أدخل الإجابة' : null,
                      ),
                    ),
                    if (question.options.length > 2)
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                          color: kLightRedColor,
                        ),
                        onPressed: () => _removeOption(optIndex),
                      ),
                  ],
                ),
              );
            }),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addOption,
                icon: const Icon(Icons.add, size: 18, color: kprimeryColor),
                label: const Text(
                  'إضافة إجابة',
                  style: TextStyle(color: kprimeryColor, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}