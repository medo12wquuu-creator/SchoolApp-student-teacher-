import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/services/chat_socket_service.dart';
import 'package:schooly/core/widgets/app_error_view.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/quiz_item_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_teacher_quiz_details/fetch_teacher_quiz_details_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_teacher_quizzes/fetch_teacher_quizzes_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/teacher_add_quiz.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/teacher_quiz_details_view.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quize_details_score_view.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quizzes_quiz_list_view.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quizzes_search_header.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/views/widgets/quizzes_status_tabs.dart';
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';

class TeacherQuizzesDetails extends StatefulWidget {
  const TeacherQuizzesDetails({super.key});

  @override
  State<TeacherQuizzesDetails> createState() => _TeacherQuizzesDetailsState();
}

class _TeacherQuizzesDetailsState extends State<TeacherQuizzesDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  TeacherChannelSubscription? _teacherSub;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<FetchTeacherQuizzesCubit>().fetchQuizzes();
    });
    _subscribeToTeacherChannel();
  }

  // 🆕 الاشتراك بقناة المعلم لاستقبال حدث انتهاء وقت الكويز (exam.time_ended)
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
    final title = data['title']?.toString() ?? 'الكويز';
    final message = data['message']?.toString() ?? 'انتهى وقت الاختبار';
    if (examId != 0 && mounted) {
      context.read<FetchTeacherQuizzesCubit>().markQuizClosed(examId);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kprimeryColor,
        action: SnackBarAction(
          label: 'عرض النتائج',
          textColor: kwhiteColor,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => QuizeDetailsScoreView(
                  quizTitle: title,
                  quizId: '$examId',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    final sub = _teacherSub;
    if (sub != null) {
      getIt<ChatSocketService>().unlistenToTeacherChannel(sub);
    }
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<QuizItemModel> _getFilteredQuizzes(
    int tabIndex,
    List<QuizItemModel> quizzes,
  ) {
    return quizzes.where((quiz) {
      final matchesSearch =
          quiz.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          quiz.description.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (tabIndex == 1) return quiz.status == QuizStatus.draft;
      if (tabIndex == 2) return quiz.status == QuizStatus.closed;
      if (tabIndex == 3) return quiz.status == QuizStatus.published;
      return true;
    }).toList();
  }

  Future<void> _openQuiz(QuizItemModel quiz) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TeacherQuizDetailsView(quizId: quiz.id, fallback: quiz),
      ),
    );
    if (mounted) context.read<FetchTeacherQuizzesCubit>().fetchQuizzes();
  }

  Future<void> _editQuiz(QuizItemModel quiz) async {
    final quizToEdit = await _loadQuizForEdit(quiz);
    if (!mounted || quizToEdit == null) return;

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TeacherAddQuiz(existing: quizToEdit)),
    );
    if (mounted) context.read<FetchTeacherQuizzesCubit>().fetchQuizzes();
  }

  Future<QuizItemModel?> _loadQuizForEdit(QuizItemModel quiz) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: kprimeryColor)),
    );
    try {
      final cubit = context.read<FetchTeacherQuizDetailsCubit>();
      await cubit.fetchQuizDetails(int.tryParse(quiz.id) ?? 0);
      final state = cubit.state;
      return state is FetchTeacherQuizDetailsSuccess ? state.quiz : quiz;
    } finally {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future<void> _deleteQuiz(QuizItemModel quiz) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'حذف الكويز',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('هل أنت متأكد من حذف هذا الكويز نهائياً؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRedColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final success = await context.read<FetchTeacherQuizzesCubit>().deleteQuiz(
      int.tryParse(quiz.id) ?? 0,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'تم حذف الكويز بنجاح' : 'فشل حذف الكويز، حاول مجدداً',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        title: const Text(
          'قائمة الكويزات',
          style: TextStyle(fontWeight: FontWeight.bold, color: kwhiteColor),
        ),
        centerTitle: true,
        backgroundColor: kprimeryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kwhiteColor),
            onPressed: () {
              context.read<FetchTeacherQuizzesCubit>().fetchQuizzes();
            },
          ),
        ],
      ),
      body: BlocBuilder<FetchTeacherQuizzesCubit, FetchTeacherQuizzesState>(
        builder: (context, state) {
          if (state is FetchTeacherQuizzesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kprimeryColor),
            );
          }
          if (state is FetchTeacherQuizzesFailure) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<FetchTeacherQuizzesCubit>().fetchQuizzes(),
            );
          }
          if (state is! FetchTeacherQuizzesSuccess) {
            return const Center(
              child: CircularProgressIndicator(color: kprimeryColor),
            );
          }
          return _buildContent(state.quizzes);
        },
      ),
    );
  }

  Widget _buildContent(List<QuizItemModel> quizzes) {
    // حساب الأعداد لكل الفئات
    final allCount = _getFilteredQuizzes(0, quizzes).length;
    final draftCount = _getFilteredQuizzes(1, quizzes).length;
    final closedCount = _getFilteredQuizzes(2, quizzes).length;
    final publishedCount = _getFilteredQuizzes(3, quizzes).length;

    return Column(
      children: [
        // --- رأس الصفحة وشريط البحث ---
        QuizzesSearchHeader(
          controller: _searchController,
          query: _searchQuery,
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
            });
          },
          onClear: () {
            _searchController.clear();
            setState(() {
              _searchQuery = '';
            });
          },
        ),

        // --- شريط التبويبات المطور بالعدد ---
        QuizzesStatusTabs(
          controller: _tabController,
          allCount: allCount,
          draftCount: draftCount,
          closedCount: closedCount,
          publishedCount: publishedCount,
          onTap: (index) {
            setState(() {});
          },
        ),

        // --- محتوى القائمة ---
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              QuizzesQuizListView(
                quizzes: _getFilteredQuizzes(0, quizzes),
                onOpen: _openQuiz,
                onEdit: _editQuiz,
                onDelete: _deleteQuiz,
              ),
              QuizzesQuizListView(
                quizzes: _getFilteredQuizzes(1, quizzes),
                onOpen: _openQuiz,
                onEdit: _editQuiz,
                onDelete: _deleteQuiz,
              ),
              QuizzesQuizListView(
                quizzes: _getFilteredQuizzes(2, quizzes),
                onOpen: _openQuiz,
                onEdit: _editQuiz,
                onDelete: _deleteQuiz,
              ),
              QuizzesQuizListView(
                quizzes: _getFilteredQuizzes(3, quizzes),
                onOpen: _openQuiz,
                onEdit: _editQuiz,
                onDelete: _deleteQuiz,
              ),
            ],
          ),
        ),
      ],
    );
  }
}