import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/class_reports/data/repo/class_reports_repo.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/classes_repo/classes_repo.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/teacher_reports_model/teacher_reports_model.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/repos/teacher_home_repo.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/teacher_quiz_repo.dart';
 
part 'teacher_reports_state.dart';

/// تجميع التقارير العامة من البيانات المتوفرة بدون الحاجة لباك جديد:
/// الكويزات (/exams) + الشعب (/teacherSections) + حصص اليوم (/teacher/todayLessons)
/// + الواجبات والاختبارات (/teacher/tasksAndHomework/{sectionId})
/// + تقارير السلوك (/teacher/reports/section/{sectionId}).
class TeacherReportsCubit extends Cubit<TeacherReportsState> {
  TeacherReportsCubit({
    required this.quizzesRepo,
    required this.classesRepo,
    required this.homeRepo,
    required this.classDetailsRepo,
    required this.classReportsRepo,
  }) : super(TeacherReportsInitial());

  final TeacherQuizzesDetailsRepo quizzesRepo;
  final ClassesRepo classesRepo;
  final TeacherHomeRepo homeRepo;
  final ClassDetailsRepo classDetailsRepo;
  final ClassReportsRepo classReportsRepo;

  Future<void> fetchReports() async {
    if (state is! TeacherReportsLoading) {
      emit(TeacherReportsLoading());
    }
    // أول خطأ يحدث أثناء الجلب — يُعرض في حال فشل كل المصادر
    Failure? firstFailure;
    try {
      // 1) إحصائيات الكويزات حسب الحالة + عدد الكويزات الموجهة لكل شعبة
      int sent = 0;
      int closed = 0;
      int draft = 0;
      final quizCountPerSection = <String, int>{};
      final quizzesRes = await quizzesRepo.fetchTeacherQuizzes();
      quizzesRes.fold(
        (failure) {
          firstFailure ??= failure;
          debugPrint('⚠️ التقارير: فشل جلب الكويزات ${failure.errMassage}');
        },
        (result) {
          for (final quiz in (result.data ?? const []).map(QuizItemModel.fromDatum)) {
            switch (quiz.status) {
              case QuizStatus.published:
                sent++;
                break;
              case QuizStatus.closed:
                closed++;
                break;
              case QuizStatus.draft:
                draft++;
                break;
            }
            for (final s in quiz.sections) {
              final id = '${s['id']}';
              quizCountPerSection[id] = (quizCountPerSection[id] ?? 0) + 1;
            }
          }
        },
      );

      // 2) شعب المعلم الحقيقية (id + name)
      final sections = <Map<String, dynamic>>[];
      final classesRes = await classesRepo.fetchTeacherClasses();
      classesRes.fold(
        (failure) {
          firstFailure ??= failure;
          debugPrint('⚠️ التقارير: فشل جلب الشعب ${failure.errMassage}');
        },
        (model) {
          void add(dynamic s) {
            if (s.id != null) {
              sections.add({'id': s.id, 'name': s.name ?? '---'});
            }
          }

          model.sections?.classA?.forEach(add);
          model.sections?.classB?.forEach(add);
        },
      );

      // 3) حصص اليوم
      int todayLessons = 0;
      final scheduleRes = await homeRepo.fetchTodaySchedual();
      scheduleRes.fold(
        (failure) {
          firstFailure ??= failure;
          debugPrint('⚠️ التقارير: فشل جلب حصص اليوم ${failure.errMassage}');
        },
        (list) => todayLessons = list.length,
      );

      // 4) الواجبات والاختبارات وتقارير السلوك لكل شعبة (الفشل لا يوقف الباقي)
      int totalHomework = 0;
      int totalTasks = 0;
      int totalClassReports = 0;
      final perSection = <SectionReportsModel>[];
      for (final s in sections) {
        final sectionId = '${s['id']}';
        int hw = 0;
        int tk = 0;
        int reports = 0;
        final hwRes = await classDetailsRepo.fetchHomework(sectionId);
        hwRes.fold(
          (failure) =>
              debugPrint('⚠️ التقارير: فشل جلب واجبات $sectionId ${failure.errMassage}'),
          (list) => hw = list.length,
        );
        final tkRes = await classDetailsRepo.fetchTasks(sectionId);
        tkRes.fold(
          (failure) =>
              debugPrint('⚠️ التقارير: فشل جلب اختبارات $sectionId ${failure.errMassage}'),
          (list) => tk = list.length,
        );
        final reportsRes =
            await classReportsRepo.fetchSectionReports(sectionId: sectionId);
        reportsRes.fold(
          (failure) => debugPrint(
              '⚠️ التقارير: فشل جلب تقارير $sectionId ${failure.errMassage}'),
          (list) => reports = list.length,
        );
        totalHomework += hw;
        totalTasks += tk;
        totalClassReports += reports;
        perSection.add(
          SectionReportsModel(
            sectionId: sectionId,
            name: s['name'] as String? ?? '---',
            homeworkCount: hw,
            tasksCount: tk,
            quizzesCount: quizCountPerSection[sectionId] ?? 0,
            classReportsCount: reports,
          ),
        );
      }

      // في حال فشل كل المصادر تماماً → عرض خطأ واضح مع التفاصيل التقنية
      final nothingLoaded = sections.isEmpty &&
          sent + closed + draft == 0 &&
          todayLessons == 0;
      if (nothingLoaded && firstFailure != null) {
        emit(
          TeacherReportsFailure(
            firstFailure!.errMassage,
            debugDetails: firstFailure!.debugDetails,
          ),
        );
        return;
      }

      emit(
        TeacherReportsSuccess(
          TeacherReportsModel(
            sentQuizzes: sent,
            closedQuizzes: closed,
            draftQuizzes: draft,
            totalSections: sections.length,
            todayLessons: todayLessons,
            totalHomework: totalHomework,
            totalTasks: totalTasks,
            totalClassReports: totalClassReports,
            sections: perSection,
          ),
        ),
      );
    } catch (e) {
      debugPrint('🔴 التقارير: خطأ غير متوقع $e');
      emit(TeacherReportsFailure(e.toString()));
    }
  }
}