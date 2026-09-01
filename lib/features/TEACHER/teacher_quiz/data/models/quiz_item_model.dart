import 'fetch_quizzes_model/datum.dart';
import 'send_quiz_model/data.dart';

// --- حالات الكويز ---
enum QuizStatus { draft, closed, published }

/// نموذج بيانات الكويز المعروض في صفحة الكويزات
class QuizItemModel {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String startsAt;
  final String endsAt;
  final List<Map<String, dynamic>> sections; // [{id, name}]
  final List<Map<String, dynamic>>
  questions; // [{body, marks, options:[{body, is_correct}]}]
  final int _customQuestionsCount; // حقل خاص لتخزين العدد القادم من الباك إيند
  QuizStatus status;

  QuizItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.startsAt,
    required this.endsAt,
    required this.sections,
    required this.questions,
    required this.status,
    int? questionsCount,
  }) : _customQuestionsCount = questionsCount ?? questions.length;

  // جلب عدد الأسئلة: يقرأ القيمة القادمة من الباك أولاً، وإذا لم توجد يحسب طول القائمة
  int get questionsCount =>
      _customQuestionsCount > 0 ? _customQuestionsCount : questions.length;

  /// تحويل كويز مسترجع من الباك إيند (Datum) إلى نموذج العرض المحلي
  factory QuizItemModel.fromDatum(Datum datum) {
    final sections = (datum.sections ?? []).map((s) {
      return {'id': s.id, 'name': s.name};
    }).toList();

    return QuizItemModel(
      id: (datum.id ?? 0).toString(),
      title: datum.title ?? '',
      description: datum.description ?? '',
      durationMinutes: datum.durationMinutes ?? 0,
      startsAt: datum.startsAt ?? '',
      endsAt: datum.endsAt ?? '',
      sections: sections,
      questions: (datum.questions ?? const [])
          .map((q) => Map<String, dynamic>.from(q))
          .toList(),
      questionsCount:
          datum.questionsCount, // قراءة عدد الأسئلة المباشر من الباك إيند
      status: _statusFromString(datum.status),
    );
  }

  /// تحويل بيانات كويز مفصّلة من الباك إيند (Data) إلى نموذج العرض المحلي
  factory QuizItemModel.fromData(Data data) {
    final sections = (data.sections ?? []).map((s) {
      return {'id': s.id, 'name': s.name};
    }).toList();

    final questions = (data.questions ?? []).map<Map<String, dynamic>>((q) {
      return {
        'body': q.body,
        'marks': q.marks,
        'options': (q.options ?? []).map((o) {
          return {'body': o.body, 'is_correct': o.isCorrect == 1};
        }).toList(),
      };
    }).toList();

    return QuizItemModel(
      id: (data.id ?? 0).toString(),
      title: data.title ?? '',
      description: data.description ?? '',
      durationMinutes: data.durationMinutes ?? 0,
      startsAt: data.startsAt ?? '',
      endsAt: data.endsAt ?? '',
      sections: sections,
      questions: questions,
      questionsCount:
          questions.length, // في التفاصيل الكلية نعتمد على طول القائمة
      status: _statusFromString(data.status),
    );
  }

  static QuizStatus _statusFromString(String? status) {
    switch (status) {
      case 'draft':
        return QuizStatus.draft;
      case 'closed':
        return QuizStatus.closed;
      case 'published':
      case 'sent':
      case 'live':
        return QuizStatus.published;
      default:
        return QuizStatus.draft;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'duration_minutes': durationMinutes,
    'starts_at': startsAt,
    'ends_at': endsAt,
    'section_ids': sections.map((s) => s['id']).toList(),
    'questions': questions,
    'status': switch (status) {
      QuizStatus.closed => 'closed',
      QuizStatus.published => 'published',
      QuizStatus.draft => 'draft',
    },
  };
}
