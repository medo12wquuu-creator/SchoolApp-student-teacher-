import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/teacher_classes_model/teacher_classes_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/teacher_classes/teacher_classes_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/send_teacher_quiz/send_teacher_quiz_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/add_quiz_date_time_tile.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/add_quiz_question_card.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/add_quiz_section_card.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/add_quiz_text_field.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quiz_form_models.dart';

class TeacherAddQuiz extends StatefulWidget {
  // 🆕 الشعب تُمرَّر من شاشة الإجراءات السريعة (شعب المعلم الحقيقية)
  final List<Map<String, dynamic>> sections;

  // 🆕 إذا كان موجوداً نكون في وضع "تعديل كويز معلق" وإلا نكون في وضع "إضافة"
  final QuizItemModel? existing;

  const TeacherAddQuiz({super.key, this.sections = const [], this.existing});

  @override
  State<TeacherAddQuiz> createState() => _TeacherAddQuizState();
}

class _TeacherAddQuizState extends State<TeacherAddQuiz> {
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.existing != null;

  // المتحكمات للنصوص العامة
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(
    text: '30',
  );

  // التواريخ والأوقات
  DateTime? _startsAt;
  DateTime? _endsAt;

  // قائمة الأسئلة
  List<QuestionModel> questions = [];

  // قائمة الشعب المتاحة (تأتي من شعب المعلم الحقيقية)
  late final List<Map<String, dynamic>> _availableSections = List.of(
    widget.sections,
  );
  final List<int> _selectedSectionIds = [];

  @override
  void initState() {
    super.initState();
    // 🆕 إن كنا في وضع التعديل نعبّئ الحقول من الكويز الحالي
    if (_isEditing) {
      final q = widget.existing!;
      _titleController.text = q.title;
      _descriptionController.text = q.description;
      _durationController.text = q.durationMinutes.toString();
      _startsAt = _tryParseDate(q.startsAt);
      _endsAt = _tryParseDate(q.endsAt);
      _selectedSectionIds.addAll(q.sections.map((s) => s['id'] as int? ?? 0));
      _availableSections.addAll(q.sections);
      // إعادة بناء الأسئلة من الكويز المحفوظ
      for (final raw in q.questions) {
        final question = QuestionModel();
        question.bodyController.text = raw['body'] as String? ?? '';
        question.marksController.text = (raw['marks'] ?? 1).toString();
        final options = (raw['options'] as List?) ?? const [];
        // نعيد بناء الخيارات فقط إن كانت موجودة، وإلا نبقي الافتراضي (2)
        if (options.isNotEmpty) {
          question.options.clear();
          for (final o in options) {
            final opt = OptionModel(
              text: (o is Map) ? o['body'] as String? ?? '' : '',
              isCorrect:
                  o is Map && (o['is_correct'] == true || o['is_correct'] == 1),
            );
            question.options.add(opt);
          }
        }
        questions.add(question);
      }
      // إذا لم تصل أسئلة من الباك نضيف سؤالاً افتراضياً ليظهر في التعديل
      if (questions.isEmpty) {
        _addQuestion();
      }
    } else {
      // 🆕 إن لم تُمرَّر الشعب من الشاشة السابقة نجلبها من الـ cubit مباشرة
      if (_availableSections.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final state = context.read<TeacherClassesCubit>().state;
          if (state is TeacherClassesSuccess) {
            setState(() {
              _availableSections.addAll(_collectSections(state.teacherClasses));
            });
          }
        });
      }
      // إضافة سؤال افتراضي عند فتح الواجهة
      _addQuestion();
    }
  }

  DateTime? _tryParseDate(String value) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  // 🆕 استخراج شعب المعلم من نموذج TeacherClassesModel
  List<Map<String, dynamic>> _collectSections(TeacherClassesModel model) {
    final result = <Map<String, dynamic>>[];
    void add(dynamic s) {
      if (s.id != null) {
        result.add({'id': s.id, 'name': s.name ?? '---'});
      }
    }

    model.sections?.classA?.forEach(add);
    model.sections?.classB?.forEach(add);
    return result;
  }

  void _addQuestion() {
    setState(() {
      questions.add(QuestionModel());
    });
  }

  void _removeQuestion(int index) {
    if (questions.length > 1) {
      setState(() {
        questions.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب أن يحتوي الاختبار على سؤال واحد على الأقل'),
        ),
      );
    }
  }

  // اختيار التاريخ والوقت
  Future<void> _selectDateTimePicker(BuildContext context, bool isStart) async {
    final DateTime initialDate = isStart
        ? (_startsAt ?? DateTime.now())
        : (_endsAt ?? DateTime.now().add(const Duration(hours: 1)));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: kprimeryColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStart) {
            _startsAt = fullDateTime;
          } else {
            _endsAt = fullDateTime;
          }
        });
      }
    }
  }

  // تجميع البيانات بصيغة JSON المماثلة لمطلب الباك إيند
  Map<String, dynamic> _buildQuizJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    return {
      "title": _titleController.text,
      "description": _descriptionController.text,
      "duration_minutes": int.tryParse(_durationController.text) ?? 0,
      "starts_at": _startsAt != null ? formatter.format(_startsAt!) : null,
      "ends_at": _endsAt != null ? formatter.format(_endsAt!) : null,
      "section_ids": _selectedSectionIds,
      "questions": questions.map((q) {
        return {
          "body": q.bodyController.text,
          "marks": int.tryParse(q.marksController.text) ?? 1,
          "options": q.options.map((opt) {
            // return {"body": opt.controller.text, "is_correct": opt.isCorrect};
            return {
              "body": opt.controller.text,
              "is_correct": opt.isCorrect ? 1 : 0,
            };
          }).toList(),
        };
      }).toList(),
    };
  }

  // التحقق العام من صحّة الكويز
  bool _validateQuiz() {
    if (!_formKey.currentState!.validate()) return false;
    if (_startsAt == null || _endsAt == null) {
      _showSnack('يرجى تحديد وقت بداية ونهاية الاختبار');
      return false;
    }
    if (_selectedSectionIds.isEmpty) {
      _showSnack('يرجى اختيار شعبة واحدة على الأقل');
      return false;
    }
    for (int i = 0; i < questions.length; i++) {
      final hasCorrect = questions[i].options.any((opt) => opt.isCorrect);
      if (!hasCorrect) {
        _showSnack('يرجى تحديد إجابة صحيحة للسؤال رقم ${i + 1}');
        return false;
      }
    }
    return true;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // 🆕 حفظ كويز: إرسال للباك إيند عبر الـ Cubit، أو تعديله إن كنا في وضع التعديل
  void _saveQuiz() {
    if (!_validateQuiz()) return;

    if (_isEditing) {
      // ✏️ تعديل كويز معلق موجود
      context.read<SendTeacherQuizCubit>().updateTeacherQuiz(
        quizId: int.tryParse(widget.existing!.id) ?? 0,
        quizData: _buildQuizJson(),
      );
    } else {
      // 🚀 إرسال كويز جديد للباك إيند
      context.read<SendTeacherQuizCubit>().sendTeacherQuiz(
        quizData: _buildQuizJson(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat displayFormat = DateFormat('yyyy/MM/dd - hh:mm a');

    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'تعديل الكويز' : 'إضافة كويز جديد',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kwhiteColor,
          ),
        ),
        backgroundColor: kprimeryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocListener<SendTeacherQuizCubit, SendTeacherQuizState>(
        listener: (context, state) {
          if (state is SendTeacherQuizSuccess) {
            // ✅ نجاح → إعلام المستخدم والعودة للشاشة السابقة
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditing
                      ? 'تم تعديل الكويز بنجاح ✅'
                      : 'تم إرسال الكويز بنجاح 🚀',
                ),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is SendTeacherQuizFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل حفظ الكويز: ${state.errMassage}')),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // --- قسم معلومات الاختبار الأساسية ---
              AddQuizSectionCard(
                title: 'المعلومات الأساسية',
                icon: Icons.assignment_outlined,
                child: Column(
                  children: [
                    AddQuizTextField(
                      controller: _titleController,
                      label: 'عنوان الكويز',
                      icon: Icons.title,
                      validator: (v) =>
                          v!.isEmpty ? 'يرجى إدخال العنوان' : null,
                    ),
                    const SizedBox(height: 12),
                    AddQuizTextField(
                      controller: _descriptionController,
                      label: 'وصف الكويز',
                      icon: Icons.description_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    AddQuizTextField(
                      controller: _durationController,
                      label: 'المدة (بالدقائق)',
                      icon: Icons.timer_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v!.isEmpty ? 'يرجى إدخال مدة الاختبار' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- قسم التوقيت والشعب ---
              AddQuizSectionCard(
                title: 'التوقيت والشعب الموجهة',
                icon: Icons.date_range,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AddQuizDateTimeTile(
                            label: 'تاريخ ووقت البداية',
                            value: _startsAt != null
                                ? displayFormat.format(_startsAt!)
                                : 'حدد الوقت',
                            onTap: () => _selectDateTimePicker(context, true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AddQuizDateTimeTile(
                            label: 'تاريخ ووقت النهاية',
                            value: _endsAt != null
                                ? displayFormat.format(_endsAt!)
                                : 'حدد الوقت',
                            onTap: () => _selectDateTimePicker(context, false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'تحديد الشعب:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_availableSections.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kbackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'لا توجد شعب مخصصة لك حالياً.',
                          style: TextStyle(color: ktextColor),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8.0,
                        children: _availableSections.map((section) {
                          final isSelected = _selectedSectionIds.contains(
                            section['id'],
                          );
                          return FilterChip(
                            label: Text(section['name']),
                            selected: isSelected,
                            selectedColor: klightPrimeryColor,
                            checkmarkColor: kprimeryColor,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? kDarkPrimaryColor
                                  : ktextColor,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedSectionIds.add(section['id']);
                                } else {
                                  _selectedSectionIds.remove(section['id']);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- عنوان قسم الأسئلة ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الأسئلة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ktextColor,
                    ),
                  ),
                  Text(
                    'عدد الأسئلة: ${questions.length}',
                    style: const TextStyle(
                      color: kDarkPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // --- قائمة الأسئلة ---
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                itemBuilder: (context, qIndex) {
                  return AddQuizQuestionCard(
                    index: qIndex,
                    question: questions[qIndex],
                    onRemoveQuestion: () => _removeQuestion(qIndex),
                    onChanged: () => setState(() {}),
                  );
                },
              ),

              const SizedBox(height: 12),

              // --- زر إضافة سؤال ---
              OutlinedButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: kprimeryColor,
                ),
                label: const Text(
                  'إضافة سؤال جديد',
                  style: TextStyle(
                    fontSize: 16,
                    color: kprimeryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: kprimeryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: klightPrimeryColor,
                ),
              ),

              const SizedBox(height: 24),

              // --- أزرار الحفظ والإلغاء ---
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimeryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'حفظ الكويز',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kwhiteColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
