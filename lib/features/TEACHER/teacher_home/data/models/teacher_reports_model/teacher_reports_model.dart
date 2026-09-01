import 'package:equatable/equatable.dart';

/// نموذج التقارير العامة لمعلم — تجميع إحصائيات من الـ APIs المتوفرة
class TeacherReportsModel extends Equatable {
  final int sentQuizzes;
  final int closedQuizzes;
  final int draftQuizzes;
  final int totalSections;
  final int todayLessons;
  final int totalHomework;
  final int totalTasks;
  final int totalClassReports;
  final List<SectionReportsModel> sections;

  const TeacherReportsModel({
    this.sentQuizzes = 0,
    this.closedQuizzes = 0,
    this.draftQuizzes = 0,
    this.totalSections = 0,
    this.todayLessons = 0,
    this.totalHomework = 0,
    this.totalTasks = 0,
    this.totalClassReports = 0,
    this.sections = const [],
  });

  int get totalQuizzes => sentQuizzes + closedQuizzes + draftQuizzes;

  int get totalActivities => totalHomework + totalTasks;

  @override
  List<Object?> get props {
    return [
      sentQuizzes,
      closedQuizzes,
      draftQuizzes,
      totalSections,
      todayLessons,
      totalHomework,
      totalTasks,
      totalClassReports,
      sections,
    ];
  }
}

/// إحصائيات شعبة واحدة (الواجبات والاختبارات والكويزات وتقارير السلوك)
class SectionReportsModel extends Equatable {
  final String sectionId;
  final String name;
  final int homeworkCount;
  final int tasksCount;
  final int quizzesCount;
  final int classReportsCount;

  const SectionReportsModel({
    required this.sectionId,
    required this.name,
    this.homeworkCount = 0,
    this.tasksCount = 0,
    this.quizzesCount = 0,
    this.classReportsCount = 0,
  });

  @override
  List<Object?> get props {
    return [
      sectionId,
      name,
      homeworkCount,
      tasksCount,
      quizzesCount,
      classReportsCount,
    ];
  }
}