import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/Grade/data/datasource/grade_remote_data_source.dart';
import 'package:schooly/features/STUDENT/Grade/data/repos/grade_repository.dart';
import 'package:schooly/features/STUDENT/Grade/presentation/view_models/grade.state.dart';
import 'package:schooly/features/STUDENT/Grade/presentation/view_models/grade_cubit.dart';
import 'package:schooly/features/STUDENT/Grade/presentation/views/widget/gpa_card.dart';
import 'package:schooly/features/STUDENT/Grade/presentation/views/widget/semester_button.dart';
import 'package:schooly/features/STUDENT/Grade/presentation/views/widget/subject_card.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/section_header.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';

class GradePage extends StatelessWidget {
  const GradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GradeCubit(
        GradeRepository(GradeRemoteDataSource(Dio())),
        context.read<UserCubit>(),
      )..loadGrades(),
      child: const StudentGradesScreen(),
    );
  }
}

class StudentGradesScreen extends StatefulWidget {
  const StudentGradesScreen({super.key});

  @override
  State<StudentGradesScreen> createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen> {
  // افتراضياً الفصل الأول مضغوط
  int _selectedSemesterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC);
    final appBarBg = isDark
        ? const Color(0xFF1A1C1E).withOpacity(0.1)
        : Colors.white.withOpacity(0.1);

    return BlocBuilder<GradeCubit, GradeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0,
            title: const Text('العلامات'),
            leading: const BackButton(),
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          body: _buildBody(context, state),
          bottomNavigationBar: _buildSemesterButtons(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, GradeState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state is GradeLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GradeError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'فشل في تحميل الدرجات. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // const SizedBox(height: 8),
              // Text(
              //   state.message,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(color: Colors.grey.shade600),
              // ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.read<GradeCubit>().loadGrades(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is GradeLoaded) {
      final data = state.data;

      if (data.semesters.isEmpty) {
        return const Center(
          child: Text(
            'لا توجد علامات بعد',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      }

      final index = _selectedSemesterIndex >= data.semesters.length
          ? 0
          : _selectedSemesterIndex;
      final semester = data.semesters[index];

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            if (semester.hasMarks)
              GPACard(
                studentTotal: semester.summary.studentTotal,
                totalMax: semester.summary.totalMax,
                rankSection: semester.summary.rankSection,
                sectionSize: semester.summary.sectionSize,
                rankClassroom: semester.summary.rankClassroom,
                classSize: semester.summary.classSize,
                sectionName: semester.semesterName,
                classroomName: semester.semesterName,
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'لا توجد علامات بعد',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 32),
            const SectionHeader(title: 'علامات المواد'),
            const SizedBox(height: 16),

            ...semester.report.map((subject) {
              final metrics = subject.types.map((type) {
                return {
                  'label': type.gradeType,
                  'score': type.score == null
                      ? '—'
                      : '${type.score!.toStringAsFixed(2)} / ${type.maxScore.toStringAsFixed(2)}',
                  'icon': _iconForType(type.gradeType),
                };
              }).toList();

              return SubjectCard(
                subject: subject.subject,
                subtitle: semester.semesterName,
                grade: subject.hasMarks
                    ? '${subject.totalScore.toStringAsFixed(2)} / ${subject.totalMax.toStringAsFixed(2)}'
                    : '—',
                total_score: subject.hasMarks ? subject.totalScore : 0,
                total_max: subject.hasMarks ? subject.totalMax : 0,
                metrics: metrics,
              );
            }),
            const SizedBox(height: 100),
          ],
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildSemesterButtons(BuildContext context, GradeState state) {
    final selectedIndex = _selectedSemesterIndex;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Row(
        children: [
          Expanded(
            child: SemesterButton(
              text: 'الفصل الأول',
              gradient: const [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
              textColor: const Color(0xFF475569),
              isSelected: selectedIndex == 0,
              onTap: () => setState(() => _selectedSemesterIndex = 0),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SemesterButton(
              text: 'الفصل الثاني',
              gradient: const [Color(0xFF1E88E5), Color(0xFF1565C0)],
              textColor: Colors.white,
              isPrimary: true,
              isSelected: selectedIndex == 1,
              onTap: () => setState(() => _selectedSemesterIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return Icons.record_voice_over;
      case 'homework':
        return Icons.assignment;
      case 'project':
        return Icons.quiz;
      case 'quiz':
        return Icons.menu_book;
      default:
        return Icons.list_alt;
    }
  }
}
