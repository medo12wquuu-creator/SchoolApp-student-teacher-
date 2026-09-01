import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_students_model/grade.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_weights_model/fetch_weights_model.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/marks/marks_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/student_details.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/student_grade_box.dart';


class ClassStudentsStudentCard extends StatefulWidget {
  final String name;
  final String finalGrade;
  final String avatarUrl;
  final String studentId;
  final String sectionId;
  final String semesterId;
  final String sectionName;
  // 🆕 أداء الطالب (ممتاز / جيد / بحاجة متابعة ...)
  final String performanceLabel;
  final Color performanceColor;
  // 🆕 الأوزان + علامات الطالب (مجمّعة من استجابة /sectionGrade)
  final List<FetchWeightsModel> weights;
  final List<Grade> grades;

  const ClassStudentsStudentCard({
    super.key,
    required this.name,
    required this.finalGrade,
    required this.avatarUrl,
    required this.studentId,
    required this.sectionId,
    required this.semesterId,
    required this.sectionName,
    required this.performanceLabel,
    required this.performanceColor,
    required this.weights,
    required this.grades,
  });

  @override
  State<ClassStudentsStudentCard> createState() =>
      _ClassStudentsStudentCardState();
}

class _ClassStudentsStudentCardState extends State<ClassStudentsStudentCard> {
  bool _isEditing = false;
  bool _isSaving = false;

  // 🆕 حقول الإدخال غير الصحيحة (علامة أكبر من الوزن)
  final Set<int> _invalidFields = {};

  // حقل إدخال لكل وزن (بموازاة قائمة الأوزان)
  late final List<TextEditingController> _controllers;

  Grade? _gradeFor(int? weightId) {
    if (weightId == null) return null;
    for (final g in widget.grades) {
      if (g.weightId == weightId) return g;
    }
    return null;
  }

  String _weightLabel(FetchWeightsModel w) {
    final name = w.gradeType?.name;
    if (name == null || name.trim().isEmpty) return 'وزن';
    return name.trim();
  }

  String _gradeValue(FetchWeightsModel w) {
    final grade = _gradeFor(w.id);
    final score = grade?.score;
    return score == null || score.isEmpty ? '—' : score;
  }

  @override
  void initState() {
    super.initState();
    _controllers = [
      for (final w in widget.weights)
        TextEditingController(text: _gradeFor(w.id)?.score ?? ''),
    ];
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // جعل الصورة قابلة للضغط للانتقال لصفحة التفاصيل
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentDetails(
                        studentName: widget.name,
                        studentPhoto: widget.avatarUrl,
                        sectionName: widget.sectionName,
                        studentId: widget.studentId,
                        semesterId: widget.semesterId,
                      ),
                    ),
                  );
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  // 🟢 التعديل الاحترافي هنا لعرض صورة الطالب وتخطي جدار الحماية الخاص بـ ngrok
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.avatarUrl,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        // إرسال الـ Headers اللازمة لحل مشكلة الـ 403 مع ngrok
                        httpHeaders: const {
                          'ngrok-skip-browser-warning': 'true',
                          'User-Agent': 'flutter-app',
                        },
                        // مؤشر تحميل دائري صغير أثناء جلب الصورة
                        placeholder: (context, url) => const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Color(0xFF4285F4),
                          ),
                        ),
                        // أيقونة افتراضية تظهر في حال فشل تحميل الصورة أو كان الرابط فارغاً
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person_rounded,
                          color: Colors.grey,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    // 🆕 الأداء بدل جملة الغياب الثابتة
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: widget.performanceColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            widget.performanceLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: widget.performanceColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!_isEditing) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FFF4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF34A853).withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    '${widget.finalGrade}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF34A853),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF4285F4),
                    size: 20,
                  ),
                  onPressed: () => setState(() {
                    _isEditing = true;
                    _invalidFields.clear();
                  }),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          _isEditing ? _buildEditForm() : _buildGradesRow(),
        ],
      ),
    );
  }

  Widget _buildGradesRow() {
    if (widget.weights.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        for (var i = 0; i < widget.weights.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: StudentGradeBox('', _gradeValue(widget.weights[i])),
          ),
        ],
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < widget.weights.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              _buildMiniTextField(
                _weightLabel(widget.weights[i]),
                _controllers[i],
                isInvalid: _invalidFields.contains(i),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _isSaving
                  ? null
                  : () {
                      setState(() {
                        _isEditing = false;
                        _invalidFields.clear();
                        for (var i = 0; i < widget.weights.length; i++) {
                          _controllers[i].text =
                              _gradeFor(widget.weights[i].id)?.score ?? '';
                        }
                      });
                    },
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isSaving ? null : () => _handleSave(context),
              child: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'حفظ',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    // 🆕 التحقق: العلامة يجب ألا تتجاوز وزنها (الدرجة العظمى)
    final invalid = <int>{};
    for (var i = 0; i < widget.weights.length; i++) {
      final text = _controllers[i].text.trim();
      if (text.isEmpty) continue;
      final value = double.tryParse(text);
      final max = double.tryParse(widget.weights[i].maxScore ?? '');
      if (value == null || value < 0 || (max != null && value > max)) {
        invalid.add(i);
      }
    }

    if (invalid.isNotEmpty) {
      setState(() {
        _invalidFields
          ..clear()
          ..addAll(invalid);
      });
      // 🆕 رسالة أنيقة وتحدد الحقل الخاطئ
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error_outline_rounded, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'لقد أدخلت علامة غير صحيحة، الرجاء الالتزام بالاوزان',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 3),
          ),
        );
      return;
    }

    setState(() => _isSaving = true);

    final grades = <Map<String, String>>[
      for (var i = 0; i < widget.weights.length; i++)
        if (_controllers[i].text.trim().isNotEmpty)
          {
            'weight_id': '${widget.weights[i].id ?? ''}',
            'score': _controllers[i].text.trim(),
          },
    ];

    if (grades.isEmpty) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أدخل علامة واحدة على الأقل قبل الحفظ'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await context.read<MarksCubit>().saveStudentMarks(
        sectionId: widget.sectionId,
        semesterId: widget.semesterId,
        studentId: widget.studentId,
        grades: grades,
      );

      if (!mounted) return;

      final state = context.read<MarksCubit>().state;
      if (state is MarksSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ العلامات بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });
      } else if (state is MarksFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errMassage),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isSaving = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء الحفظ: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildMiniTextField(
    String label,
    TextEditingController controller, {
    bool isInvalid = false,
  }) {
    final borderColor = isInvalid
        ? Colors.redAccent
        : Colors.grey.withOpacity(0.2);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isInvalid ? Colors.redAccent : Colors.grey,
                  fontWeight: isInvalid ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isInvalid) ...[
                const SizedBox(width: 2),
                const Icon(
                  Icons.error_rounded,
                  size: 11,
                  color: Colors.redAccent,
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 36,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: isInvalid
                    ? Colors.redAccent.withOpacity(0.06)
                    : const Color(0xFFF8F9FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor, width: isInvalid ? 1.5 : 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isInvalid ? Colors.redAccent : const Color(0xFF4285F4),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}