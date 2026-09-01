import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_students_model/fetch_students_model.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_students_model/grade.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_weights_model/fetch_weights_model.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/marks/marks_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/students/fetch_students_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/class_student_performence.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/class_students_header.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/class_students_states_section.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/class_students_student_card.dart';


class ClassStudentsBody extends StatefulWidget {
  final String sectionId;
  final String semesterId;
  final String? semesterName;
  final String sectionName;

  const ClassStudentsBody({
    super.key,
    required this.sectionId,
    required this.semesterId,
    this.semesterName,
    required this.sectionName,
  });

  @override
  State<ClassStudentsBody> createState() => _ClassStudentsBodyState();
}

class _ClassStudentsBodyState extends State<ClassStudentsBody> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<FetchStudentsCubit>().fetchStudents(
      sectionId: widget.sectionId,
      semesterId: widget.semesterId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FE),
        body: SafeArea(
          child: BlocListener<MarksCubit, MarksState>(
            listener: (context, state) {
              if (state is MarksSuccess) {
                context.read<FetchStudentsCubit>().fetchStudents(
                  sectionId: widget.sectionId,
                  semesterId: widget.semesterId,
                );
              }
            },
            child: BlocBuilder<FetchStudentsCubit, FetchStudentsState>(
              builder: (context, state) {
                if (state is FetchStudentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is FetchStudentsFailure) {
                  return Center(child: Text(state.errMassage));
                }
                if (state is FetchStudentsSuccess) {
                  final students = state.students;
                  final weights = state.weights;

                  // 🆕 حساب معدلات الطلاب فقط عند اكتمال كل العلامات
                  final averages = <double>[];
                  var allMarksComplete = students.isNotEmpty;
                  for (final student in students) {
                    final grades = student.grades ?? const <Grade>[];
                    final hasAllWeights = weights.isNotEmpty &&
                        weights.every(
                          (w) => grades.any((g) => g.weightId == w.id),
                        );
                    if (!hasAllWeights) {
                      allMarksComplete = false;
                      continue;
                    }
                    final maxTotal = student.maxTotal ?? 0;
                    final total = student.total ?? 0;
                    averages.add(
                      maxTotal > 0 ? (total / maxTotal) * 100 : 0,
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClassesDetailsPerformanceCard(
                          grades: allMarksComplete ? averages : const [],
                          semesterName: widget.semesterName,
                          showWaiting: !allMarksComplete,
                        ),
                        const SizedBox(height: 12),
                        ClassStudentsStatesSection(
                          studentCount: students.length.toString(),
                          successRate: _calcSuccessRate(
                            students,
                          ).toStringAsFixed(0),
                          topScore: _calcTopScore(students).toStringAsFixed(1),
                        ),
                        const SizedBox(height: 16),

                        // 🆕 عرض الأوزان في سطر واحد منسّق فوق قائمة الطلاب
                        if (weights.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: klightPrimeryColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: kprimeryColor.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                for (
                                  var i = 0;
                                  i < weights.length;
                                  i++
                                ) ...[
                                  if (i > 0)
                                    Container(
                                      width: 1,
                                      height: 26,
                                      color: kprimeryColor.withOpacity(0.2),
                                    ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            weights[i].gradeType?.name ??
                                                'وزن',
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: kprimeryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'من ${weights[i].maxScore ?? '0'}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: ktextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 8),

                        // 🟢 التعديل الذكي هنا: دمج الهيدر مع زر "أخذ الحضور" بشكل متناسق ومحاذاته لليسار
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(child: ClassStudentsHeader()),
                            // زر أخذ الحضور الأنيق
                          ],
                        ),

                        const SizedBox(height: 16),
                        ...students.map((student) {
                          final performance = _performanceFor(
                            student,
                            weights,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ClassStudentsStudentCard(
                              name: student.name ?? '---',
                              finalGrade: '${student.total ?? '0'}',
                              avatarUrl: student.personalPhoto ?? '',
                              studentId: '${student.id ?? ''}',
                              sectionId: widget.sectionId,
                              semesterId: widget.semesterId,
                              sectionName: widget.sectionName,
                              // 🆕 أداء الطالب
                              performanceLabel: performance.$1,
                              performanceColor: performance.$2,
                              // 🆕 تمرير الأوزان والعلامات للعرض حسب كل وزن
                              weights: weights,
                              grades: student.grades ?? const [],
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  double _calcSuccessRate(List<FetchStudentsModel> students) {
    if (students.isEmpty) return 0;
    final passed = students.where((s) => (s.total ?? 0) >= 50).length;
    return (passed / students.length) * 100;
  }

  double _calcTopScore(List<FetchStudentsModel> students) {
    if (students.isEmpty) return 0;
    return students
        .map((s) => (s.total ?? 0).toDouble())
        .reduce((a, b) => a > b ? a : b);
  }

  // 🆕 تحديد أداء الطالب من الأوزان المكتملة فقط (لا من المجموع الكلي)
  (String, Color) _performanceFor(
    FetchStudentsModel student,
    List<FetchWeightsModel> weights,
  ) {
    if (weights.isEmpty) return ('قيد التقييم', ktextColor);

    final grades = student.grades ?? const <Grade>[];
    var scoreSum = 0.0;
    var maxSum = 0.0;
    var collected = 0;

    for (final w in weights) {
      Grade? grade;
      for (final g in grades) {
        if (g.weightId == w.id) {
          grade = g;
          break;
        }
      }
      if (grade == null || grade.score == null) continue;
      final s = double.tryParse(grade.score!);
      final m = double.tryParse(grade.maxScore ?? w.maxScore ?? '');
      if (s == null || m == null || m <= 0) continue;
      scoreSum += s;
      maxSum += m;
      collected++;
    }

    // 🔻 شرط الاكتمال: أقل من 60% من الأوزان مسجّلة → قيد التقييم
    if (collected == 0 || collected / weights.length < 0.6) {
      return ('قيد التقييم', ktextColor);
    }

    final percentage = (scoreSum / maxSum) * 100;
    if (percentage >= 90) return ('ممتاز', kadditionalColor);
    if (percentage >= 80) return ('جيد جداً', kadditionalColor);
    if (percentage >= 70) return ('جيد', kprimeryColor);
    if (percentage >= 60) return ('مقبول', kseconderyColor);
    return ('بحاجة متابعة', kRedColor);
  }
}
