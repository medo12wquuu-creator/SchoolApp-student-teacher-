import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/widgets/app_snack_bar.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_send_homework/send_homework_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_send_task/send_task_cubit.dart';

enum HomeworkOrExam { homework, exam }

class ClassDetailsAddDialog extends StatefulWidget {
  final HomeworkOrExam type;
  final String sectionId;

  const ClassDetailsAddDialog({
    super.key,
    required this.type,
    required this.sectionId,
  });

  @override
  State<ClassDetailsAddDialog> createState() => _ClassDetailsAddDialogState();
}

class _ClassDetailsAddDialogState extends State<ClassDetailsAddDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool _isButtonEnabled = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _dateController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled =
          _titleController.text.trim().isNotEmpty &&
          _dateController.text.trim().isNotEmpty;
    });
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );

    if (pickedDate != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      _validateForm();
    }
  }

  void _submit() {
    if (!_isButtonEnabled) return;
    setState(() => _isSending = true);

    final isHomework = widget.type == HomeworkOrExam.homework;
    // 🆕 العنوان يُرسل كـ title و description معاً لضمان ظهوره في القوائم
    final title = _titleController.text.trim();

    if (isHomework) {
      context.read<SendHomeworkCubit>().sendHomework(
        sectionId: widget.sectionId,
        type: 'homework',
        title: title,
        description: title,
        deliveryDate: _dateController.text,
      );
    } else {
      context.read<SendTaskCubit>().sendTask(
        sectionId: widget.sectionId,
        type: 'Quiz',
        title: title,
        description: title,
        deliveryDate: _dateController.text,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: ktextColor.withOpacity(0.4), fontSize: 13),
      filled: true,
      fillColor: klightPrimeryColor.withOpacity(0.4),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: kprimeryColor, size: 20)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: ktextColor.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kprimeryColor, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHomework = widget.type == HomeworkOrExam.homework;
    final dialogTitle = isHomework ? 'إضافة واجب بيتي' : 'إضافة اختبار جديد';
    final mainColor = isHomework ? kprimeryColor : kadditionalColor;

    return PopScope(
      canPop: false,
      child: BlocListener<SendHomeworkCubit, SendHomeworkState>(
        listener: (context, state) {
          if (state is SendHomeworkSuccess) {
            Navigator.pop(context, true);
          } else if (state is SendHomeworkFailure) {
            setState(() => _isSending = false);
            showAppErrorSnackBar(context, state.errMassage, title: 'تعذر الحفظ');
          }
        },
        child: BlocListener<SendTaskCubit, SendTaskState>(
          listener: (context, state) {
            if (state is SendTaskSuccess) {
              Navigator.pop(context, true);
            } else if (state is SendTaskFailure) {
              setState(() => _isSending = false);
              showAppErrorSnackBar(context, state.errMassage, title: 'تعذر الحفظ');
            }
          },
          child: Dialog(
            backgroundColor: kwhiteColor,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isHomework
                            ? Icons.assignment_rounded
                            : Icons.quiz_rounded,
                        color: mainColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      dialogTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _titleController,
                      decoration: _buildInputDecoration(
                        hintText: isHomework
                            ? 'العنوان (مثال: حل التمارين)'
                            : 'العنوان (مثال: اختبار الفصل الأول)',
                        prefixIcon: Icons.title_rounded,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: _buildInputDecoration(
                        hintText: isHomework
                            ? 'تاريخ التسليم'
                            : 'تاريخ الاختبار',
                        prefixIcon: Icons.calendar_month_rounded,
                      ),
                    ),
                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                color: ktextColor.withOpacity(0.2),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(color: ktextColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              disabledBackgroundColor: Colors.grey.shade300,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isButtonEnabled && !_isSending
                                ? _submit
                                : null,
                            child: _isSending
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'حفظ البيانات',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}