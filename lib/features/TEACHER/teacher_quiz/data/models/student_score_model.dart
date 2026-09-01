import 'fetch_quiz_score_model/fetch_quiz_score_model.dart';

/// حالة الطالب في كويز مغلق:
/// - submitted: قدّم الكويز وله علامة
/// - timeout: انتهت مدة الكويز وله علامة
/// - notAttempted: لم يحاول وليس له علامة
enum QuizStudentStatus { submitted, timeout, notAttempted }

class SectionScoresModel {
  final int sectionId;
  final String sectionName;
  final List<StudentScoreModel> students;

  SectionScoresModel({
    required this.sectionId,
    required this.sectionName,
    required this.students,
  });
}

class StudentScoreModel {
  final String id;
  final String name;
  final double score;
  final double maxScore;
  final QuizStudentStatus status;
  final String? submittedAt;

  StudentScoreModel({
    required this.id,
    required this.name,
    required this.score,
    required this.maxScore,
    this.status = QuizStudentStatus.submitted,
    this.submittedAt,
  });

  double get percentage => maxScore > 0 ? (score / maxScore) : 0.0;

  /// submitted و timeout لهما علامات، و notAttempted ليس له علامة
  bool get hasMarks =>
      status == QuizStudentStatus.submitted ||
      status == QuizStudentStatus.timeout;
}

QuizStudentStatus quizStudentStatusFromString(String? raw) {
  final value = (raw ?? '').trim().toLowerCase();
  if (value == 'timeout') return QuizStudentStatus.timeout;
  if (value == 'not_attempted' ||
      value == 'not attempted' ||
      value == 'no_attempt' ||
      value == 'absent' ||
      value == 'missed' ||
      value == 'none') {
    return QuizStudentStatus.notAttempted;
  }
  return QuizStudentStatus.submitted;
}

/// تحويل استجابة الباك (FetchQuizScoreModel) إلى بنية شعب الطلاب للواجهة
List<SectionScoresModel> buildSectionScoresFromModel(FetchQuizScoreModel model) {
  return (model.sections ?? const [])
      .where((s) => s.students != null && s.students!.isNotEmpty)
      .map(
        (s) => SectionScoresModel(
          sectionId: s.sectionId ?? 0,
          sectionName: s.sectionName ?? 'شعبة',
          students: s.students!
              .map(
                (st) => StudentScoreModel(
                  id: (st.studentId ?? 0).toString(),
                  name: st.name ?? '',
                  score: (st.score ?? 0).toDouble(),
                  maxScore: (st.total ?? 0).toDouble(),
                  status: quizStudentStatusFromString(st.status),
                  submittedAt: st.submittedAt,
                ),
              )
              .toList(),
        ),
      )
      .toList();
}