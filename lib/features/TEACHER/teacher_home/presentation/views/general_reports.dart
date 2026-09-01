import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/widgets/app_error_view.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/teacher_reports_model/teacher_reports_model.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/teacher_reports/teacher_reports_cubit.dart';
 
/// صفحة التقارير العامة — لوحة تحكم من البيانات المتوفرة (المرحلة 1)
class GeneralReports extends StatefulWidget {
  const GeneralReports({super.key});

  @override
  State<GeneralReports> createState() => _GeneralReportsState();
}

class _GeneralReportsState extends State<GeneralReports> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<TeacherReportsCubit>().fetchReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        title: const Text(
          'التقارير العامة',
          style: TextStyle(color: kwhiteColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kprimeryColor,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'تحديث',
            onPressed: () =>
                getIt<TeacherReportsCubit>().fetchReports(),
            icon: const Icon(Icons.refresh_rounded, color: kwhiteColor),
          ),
        ],
      ),
      body: BlocProvider.value(
        value: getIt<TeacherReportsCubit>(),
        child: BlocBuilder<TeacherReportsCubit, TeacherReportsState>(
          builder: (context, state) {
            if (state is TeacherReportsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: kprimeryColor),
              );
            }
            if (state is TeacherReportsFailure) {
              return AppErrorView(
                message: state.message,
                debugDetails: state.debugDetails,
                onRetry: () =>
                    getIt<TeacherReportsCubit>().fetchReports(),
              );
            }
            if (state is TeacherReportsSuccess) {
              return _buildDashboard(state.reports);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDashboard(TeacherReportsModel model) {
    final maxSectionCount = model.sections.fold<int>(
      0,
      (max, s) => [
        max,
        s.homeworkCount,
        s.tasksCount,
        s.classReportsCount,
      ].reduce((a, b) => a > b ? a : b),
    );
    final maxQuizCount = model.sections.fold<int>(
      0,
      (max, s) => s.quizzesCount > max ? s.quizzesCount : max,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeroCard(model),
        const SizedBox(height: 20),
        const _SectionTitle('نظرة عامة'),
        const SizedBox(height: 12),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 76,
          ),
          children: [
            _buildStatCard(
              icon: Icons.send_rounded,
              label: 'كويزات مرسلة',
              value: model.sentQuizzes,
              color: kprimeryColor,
            ),
            _buildStatCard(
              icon: Icons.lock_rounded,
              label: 'كويزات مغلقة',
              value: model.closedQuizzes,
              color: kseconderyColor,
            ),
            _buildStatCard(
              icon: Icons.schedule_rounded,
              label: 'كويزات معلقة',
              value: model.draftQuizzes,
              color: kDarkPrimaryColor.withOpacity(0.6),
            ),
            _buildStatCard(
              icon: Icons.groups_rounded,
              label: 'عدد الشعب',
              value: model.totalSections,
              color: kprimeryColor.withOpacity(0.7),
            ),
            _buildStatCard(
              icon: Icons.menu_book_rounded,
              label: 'حصص اليوم',
              value: model.todayLessons,
              color: kDarkPrimaryColor,
            ),
            _buildStatCard(
              icon: Icons.assignment_rounded,
              label: 'واجبات واختبارات',
              value: model.totalActivities,
              color: kadditionalColor,
            ),
            _buildStatCard(
              icon: Icons.fact_check_rounded,
              label: 'تقارير السلوك',
              value: model.totalClassReports,
              color: kLightRedColor,
            ),
          ],
        ),
        if (model.sections.isNotEmpty) ...[
          const SizedBox(height: 24),
          const _SectionTitle('كويزات كل شعبة'),
          const SizedBox(height: 4),
          Text(
            'عدد الكويزات الموجهة لكل شعبة',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          ...model.sections.map(
            (s) => _buildQuizBar(s, maxQuizCount),
          ),
        ],
        const SizedBox(height: 24),
        const _SectionTitle('مقارنة الشعب'),
        const SizedBox(height: 4),
        Text(
          'توزيع الواجبات والاختبارات وتقارير السلوك بين الشعب',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        if (model.sections.isEmpty)
          _buildEmptySections()
        else
          ...model.sections.map(
            (s) => _buildSectionBar(s, maxSectionCount),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeroCard(TeacherReportsModel model) {
    final total = model.totalQuizzes + model.totalActivities + model.totalClassReports;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kprimeryColor, kDarkPrimaryColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kprimeryColor.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إجمالي الأنشطة التعليمية',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  '$total',
                  style: const TextStyle(
                    color: kwhiteColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'كويزات وواجبات واختبارات وتقارير عبر شعبك',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.insights_rounded,
            color: Colors.white70,
            size: 56,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: kwhiteColor, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: ktextColor,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionBar(SectionReportsModel section, int maxCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ktextColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: ktextColor,
            ),
          ),
          const SizedBox(height: 10),
          _buildBarRow(
            label: 'الواجبات',
            value: section.homeworkCount,
            maxCount: maxCount,
            color: kprimeryColor,
          ),
          const SizedBox(height: 6),
          _buildBarRow(
            label: 'الاختبارات',
            value: section.tasksCount,
            maxCount: maxCount,
            color: kseconderyColor,
          ),
          const SizedBox(height: 6),
          _buildBarRow(
            label: 'تقارير السلوك',
            value: section.classReportsCount,
            maxCount: maxCount,
            color: kLightRedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizBar(SectionReportsModel section, int maxCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: ktextColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              section.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: ktextColor,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  Container(height: 12, color: kprimeryColor.withOpacity(0.12)),
                  FractionallySizedBox(
                    widthFactor: maxCount == 0 ? 0 : section.quizzesCount / maxCount,
                    alignment: Alignment.centerLeft,
                    child: Container(height: 12, color: kprimeryColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 26,
            child: Text(
              '${section.quizzesCount}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: ktextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarRow({
    required String label,
    required int value,
    required int maxCount,
    required Color color,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(height: 12, color: color.withOpacity(0.12)),
                FractionallySizedBox(
                  widthFactor: maxCount == 0 ? 0 : value / maxCount,
                  alignment: Alignment.centerLeft,
                  child: Container(height: 12, color: color),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 26,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ktextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySections() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'لا توجد شعب للمقارنة حالياً',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: ktextColor,
      ),
    );
  }
}