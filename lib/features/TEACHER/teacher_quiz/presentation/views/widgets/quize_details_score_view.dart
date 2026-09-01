import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/widgets/app_error_view.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/models/student_score_model.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_quiz_score/fetch_quiz_score_cubit.dart';

class QuizeDetailsScoreView extends StatefulWidget {
  final String quizTitle;
  final String quizId;

  const QuizeDetailsScoreView({
    super.key,
    required this.quizTitle,
    required this.quizId,
  });

  @override
  State<QuizeDetailsScoreView> createState() => _QuizeDetailsScoreViewState();
}

class _QuizeDetailsScoreViewState extends State<QuizeDetailsScoreView> {
  int _selectedSectionIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // جلب علامات الطلاب من الباك إيند عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context
          .read<FetchQuizScoreCubit>()
          .fetchQuizScore(int.tryParse(widget.quizId) ?? 0);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.quizTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: kwhiteColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: kprimeryColor,
        elevation: 0,
      ),
      body: BlocBuilder<FetchQuizScoreCubit, FetchQuizScoreState>(
        builder: (context, state) {
          if (state is FetchQuizScoreLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kprimeryColor),
            );
          }
          if (state is FetchQuizScoreFailure) {
            return AppErrorView(
              message: state.message,
              debugDetails: state.debugDetails,
              onRetry: () => context
                  .read<FetchQuizScoreCubit>()
                  .fetchQuizScore(int.tryParse(widget.quizId) ?? 0),
            );
          }
          if (state is FetchQuizScoreSuccess) {
            final sections = buildSectionScoresFromModel(state.quizScore);
            if (sections.isEmpty) {
              return _buildEmptyView();
            }
            return _buildContent(sections);
          }
          return const Center(
            child: CircularProgressIndicator(color: kprimeryColor),
          );
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.assignment_late_outlined,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد نتائج لهذا الكويز بعد',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<SectionScoresModel> sections) {
    if (_selectedSectionIndex >= sections.length) {
      _selectedSectionIndex = 0;
    }
    final currentSection = sections[_selectedSectionIndex];

    final filteredStudents = currentSection.students.where((student) {
      return student.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuizHeaderSummary(sections),
        _buildSectionsBar(sections),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'ابحث عن اسم طالب...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: kprimeryColor),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: kwhiteColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: filteredStudents.isEmpty
              ? Center(
                  child: Text(
                    'لا يوجد طلاب مطابقين للبحث',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    return _buildStudentCard(filteredStudents[index]);
                  },
                ),
        ),
      ],
    );
  }

  // ملخص إحصائي متميز أعلى القائمة يعرض حالات الطلاب الثلاث
  Widget _buildQuizHeaderSummary(List<SectionScoresModel> sections) {
    int totalStudents = 0;
    int submitted = 0;
    int timeout = 0;
    int notAttempted = 0;
    for (final sec in sections) {
      for (final st in sec.students) {
        totalStudents++;
        switch (st.status) {
          case QuizStudentStatus.submitted:
            submitted++;
          case QuizStudentStatus.timeout:
            timeout++;
          case QuizStudentStatus.notAttempted:
            notAttempted++;
        }
      }
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kprimeryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kwhiteColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'إجمالي الطلاب',
                  '$totalStudents طالب',
                  Icons.people_outline,
                ),
                Container(height: 24, width: 1, color: Colors.white24),
                _buildStatItem(
                  'الشعب المقدمة',
                  '${sections.length} شعب',
                  Icons.class_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStatusChip('قدموا', submitted, const Color(0xFF10B981)),
              _buildStatusChip(
                'انتهت المدة',
                timeout,
                const Color(0xFFF59E0B),
              ),
              _buildStatusChip(
                'لم يحاولوا',
                notAttempted,
                Colors.grey.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: const TextStyle(
                color: kwhiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: kwhiteColor.withOpacity(0.85),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: kwhiteColor, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: kwhiteColor.withOpacity(0.8), fontSize: 11),
            ),
            Text(
              value,
              style: const TextStyle(
                color: kwhiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // شريط التبديل بين الشعب بصورة مستقلة ومريحة
  Widget _buildSectionsBar(List<SectionScoresModel> sections) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اختر الشعبة:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: ktextColor,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedSectionIndex == index;
                final sec = sections[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSectionIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? kprimeryColor : kwhiteColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? kprimeryColor
                            : Colors.grey.shade300,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: kprimeryColor.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.groups_rounded,
                          size: 16,
                          color: isSelected
                              ? kwhiteColor
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          sec.sectionName,
                          style: TextStyle(
                            color: isSelected ? kwhiteColor : ktextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.2)
                                : klightPrimeryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${sec.students.length}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? kwhiteColor
                                  : kDarkPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(StudentScoreModel student) {
    final statusColor = switch (student.status) {
      QuizStudentStatus.submitted => const Color(0xFF10B981),
      QuizStudentStatus.timeout => const Color(0xFFF59E0B),
      QuizStudentStatus.notAttempted => Colors.grey.shade400,
    };
    final statusLabel = switch (student.status) {
      QuizStudentStatus.submitted => 'قدّم الكويز',
      QuizStudentStatus.timeout => 'انتهت مدة الكويز',
      QuizStudentStatus.notAttempted => 'لم يحاول',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: statusColor.withOpacity(0.15),
                radius: 20,
                child: Text(
                  student.name.isNotEmpty ? student.name[0] : '؟',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ktextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: student.hasMarks
                    ? Text(
                        '${student.score.toStringAsFixed(0)} / ${student.maxScore.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      )
                    : Text(
                        'بلا علامة',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
              ),
            ],
          ),
          if (student.hasMarks) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: student.percentage > 1 ? 1.0 : student.percentage,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(student.percentage * 100).round()}%',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                if (student.submittedAt != null &&
                    student.submittedAt!.isNotEmpty)
                  Text(
                    student.submittedAt!,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'لم يقم الطالب بمحاولة أداء الكويز',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}