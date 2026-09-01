 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/text_styles.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/teacher_classes_model/teacher_classes_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/teacher_classes/teacher_classes_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/general_reports.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/widgets/quick_actions_button.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/teacher_add_quiz.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/teacher_quizzes_details.dart';
 class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  // 🆕 تجميع شعب المعلم الحقيقية من بيانات الـ cubit (id + name)
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'إجراءات سريعة',
              style: Styles.textStyle16.copyWith(
                color: ktextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      kprimeryColor.withOpacity(0.3),
                      kprimeryColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            children: [
              QuickActionsButton(
                context: context,
                icon: Icons.post_add_rounded,
                text: "إضافة كويز",
                backgroundColor: kprimeryColor,
                foregroundColor: kwhiteColor,
                onPressed: () {
                  // 🆕 تمرير شعب المعلم الحقيقية إلى صفحة إضافة الكويز
                  final state = context.read<TeacherClassesCubit>().state;
                  List<Map<String, dynamic>> sections = [];
                  if (state is TeacherClassesSuccess) {
                    sections = _collectSections(state.teacherClasses);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TeacherAddQuiz(sections: sections),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              QuickActionsButton(
                context: context,
                icon: Icons.notes_rounded,
                text: "الكويزات",
                backgroundColor: kseconderyColor.withOpacity(0.2),
                foregroundColor: ktextColor,
                onPressed: () {
                  // 🆕 الانتقال لصفحة قائمة الكويزات
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TeacherQuizzesDetails(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              QuickActionsButton(
                context: context,
                icon: Icons.insights_rounded,
                text: "التقارير العامة",
                backgroundColor: kLightRedColor.withOpacity(0.3),
                foregroundColor: kRedColor,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const GeneralReports(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
