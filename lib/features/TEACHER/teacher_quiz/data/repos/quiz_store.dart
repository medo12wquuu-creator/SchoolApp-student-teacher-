import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';

/// مخزن مؤقت للكويزات في الذاكرة (بدون باك إند — للتجربة بالتصميم فقط)
class QuizStore {
  final List<QuizItemModel> _quizzes = [];

  List<QuizItemModel> get all => List.unmodifiable(_quizzes);

  List<QuizItemModel> get draft =>
      _quizzes.where((q) => q.status == QuizStatus.draft).toList();

  List<QuizItemModel> get published =>
      _quizzes.where((q) => q.status == QuizStatus.published).toList();

  void add(QuizItemModel quiz) {
    _quizzes.insert(0, quiz);
  }

  void update(QuizItemModel updated) {
    final index = _quizzes.indexWhere((q) => q.id == updated.id);
    if (index != -1) _quizzes[index] = updated;
  }

  void publish(String id) {
    final index = _quizzes.indexWhere((q) => q.id == id);
    if (index != -1) _quizzes[index].status = QuizStatus.published;
  }

  void delete(String id) {
    _quizzes.removeWhere((q) => q.id == id);
  }
}
