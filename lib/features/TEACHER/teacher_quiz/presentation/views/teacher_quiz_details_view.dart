import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/services/chat_socket_service.dart';
import 'package:schooly/core/widgets/app_error_view.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_teacher_quiz_details/fetch_teacher_quiz_details_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_teacher_quizzes/fetch_teacher_quizzes_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quiz_details_body.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quiz_details_publish_bar.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quiz_details_view_scores_bar.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quize_details_score_view.dart';
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';

// 📄 صفحة عرض تفاصيل الكويز
class TeacherQuizDetailsView extends StatefulWidget {
  final String quizId;
  final QuizItemModel? fallback;

  const TeacherQuizDetailsView({super.key, required this.quizId, this.fallback});

  @override
  State<TeacherQuizDetailsView> createState() => _TeacherQuizDetailsViewState();
}

class _TeacherQuizDetailsViewState extends State<TeacherQuizDetailsView> {
  bool _publishing = false;
  QuizItemModel? _currentQuiz;
  TeacherChannelSubscription? _teacherSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FetchTeacherQuizDetailsCubit>().fetchQuizDetails(
        int.tryParse(widget.quizId) ?? 0,
      );
    });
    _subscribeToTeacherChannel();
  }

  // 🆕 الاشتراك بقناة المعلم لتحويل الكويز المرسل إلى مغلق فور انتهاء وقته
  void _subscribeToTeacherChannel() {
    final user = getIt<UserCubitt>().currentUser;
    if (user == null) return;
    _teacherSub = getIt<ChatSocketService>().listenToTeacherChannel(
      userId: user.id,
      onExamTimeEnded: _onExamTimeEnded,
    );
  }

  void _onExamTimeEnded(Map<String, dynamic> data) {
    final examId = int.tryParse('${data['exam_id'] ?? ''}') ?? 0;
    final currentQuizId = int.tryParse(widget.quizId) ?? 0;
    if (examId != currentQuizId) return;
    if (!mounted) return;

    final quiz = _currentQuiz;
    if (quiz == null || quiz.status == QuizStatus.closed) return;

    // 🆕 تحويل الكويز إلى مغلق → يظهر زر عرض النتائج تلقائياً
    setState(() => quiz.status = QuizStatus.closed);

    // 🆕 جلب النتائج تلقائياً بفتح شاشة العلامات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => QuizeDetailsScoreView(
            quizTitle: quiz.title,
            quizId: widget.quizId,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    final sub = _teacherSub;
    if (sub != null) {
      getIt<ChatSocketService>().unlistenToTeacherChannel(sub);
    }
    super.dispose();
  }

  bool get _isPending => _currentQuiz?.status == QuizStatus.draft;
  bool get _isClosed => _currentQuiz?.status == QuizStatus.closed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        title: const Text(
          'تفاصيل الكويز',
          style: TextStyle(fontWeight: FontWeight.bold, color: kwhiteColor),
        ),
        centerTitle: true,
        backgroundColor: kprimeryColor,
        elevation: 0,
      ),
      bottomNavigationBar: _isPending
          ? QuizDetailsPublishBar(
              publishing: _publishing,
              onPressed: () => _publishQuiz(context),
            )
          : (_isClosed
                ? QuizDetailsViewScoresBar(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuizeDetailsScoreView(
                            quizTitle: _currentQuiz?.title ?? 'الكويز',
                            quizId: widget.quizId,
                          ),
                        ),
                      );
                    },
                  )
                : null),
      body:
          BlocListener<
            FetchTeacherQuizDetailsCubit,
            FetchTeacherQuizDetailsState
          >(
            listener: (context, state) {
              if (state is FetchTeacherQuizDetailsSuccess) {
                setState(() => _currentQuiz = state.quiz);
              } else if (state is FetchTeacherQuizDetailsFailure &&
                  _currentQuiz == null &&
                  widget.fallback != null) {
                setState(() => _currentQuiz = widget.fallback);
              }
            },
            child:
                BlocBuilder<
                  FetchTeacherQuizDetailsCubit,
                  FetchTeacherQuizDetailsState
                >(
                  builder: (context, state) {
                    if (state is FetchTeacherQuizDetailsLoading &&
                        _currentQuiz == null) {
                      return const Center(
                        child: CircularProgressIndicator(color: kprimeryColor),
                      );
                    }
                    if (state is FetchTeacherQuizDetailsFailure &&
                        _currentQuiz == null) {
                      return AppErrorView(
                        message: state.message,
                        onRetry: () =>
                            context.read<FetchTeacherQuizDetailsCubit>().fetchQuizDetails(
                              int.tryParse(widget.quizId) ?? 0,
                            ),
                      );
                    }
                    final quiz = _currentQuiz;
                    if (quiz == null) {
                      return const Center(
                        child: CircularProgressIndicator(color: kprimeryColor),
                      );
                    }
                    return QuizDetailsBody(quiz: quiz);
                  },
                ),
          ),
    );
  }

  Future<void> _publishQuiz(BuildContext context) async {
    final quiz = _currentQuiz;
    if (quiz == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'نشر الكويز',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'هل أنت متأكد من نشر هذا الكويز؟ سيصبح متاحاً للطلاب فوراً.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kadditionalColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'نشر الآن',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _publishing = true);
    final success = await context.read<FetchTeacherQuizzesCubit>().publishQuiz(
      int.tryParse(quiz.id) ?? 0,
    );
    if (!mounted) return;
    setState(() => _publishing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'تم نشر الكويز بنجاح 🚀' : 'فشل نشر الكويز، حاول مجدداً',
        ),
      ),
    );
    Navigator.of(context).pop();
  }
}