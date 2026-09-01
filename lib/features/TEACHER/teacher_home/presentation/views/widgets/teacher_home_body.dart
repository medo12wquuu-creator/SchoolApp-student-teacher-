 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/text_styless.dart';
import 'package:schooly/core/widgets/custom_error_widget.dart';
import 'package:schooly/core/widgets/teacher_home_date.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/teacher_classes/teacher_classes_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/fetch_teacher_profile_info/fetch_profile_info_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/today_shedual/today_schedual_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/widgets/home_lessons_card.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/widgets/home_sections_card.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/widgets/quick_actions.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/widgets/today_schedual.dart';
 class TeacherHomeBody extends StatefulWidget {
  const TeacherHomeBody({super.key});

  @override
  State<TeacherHomeBody> createState() => _TeacherHomeBodyState();
}

class _TeacherHomeBodyState extends State<TeacherHomeBody> {
  @override
  void initState() {
    super.initState();
    _triggerInitialEvents();
  }

  void _triggerInitialEvents() {
    context.read<FetchProfileInfoCubit>().fetchProfileInfo();
    context.read<TodaySchedualCubit>().fetchTodaySchedual();
    // 🆕 جلب عدد الشعب لعرضه في كارت "شعبك"
    context.read<TeacherClassesCubit>().fetchTeacherClasses();
  }

  // 🆕 إعادة تحميل كل بيانات الهوم عند سحب الشاشة للأسفل
  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<FetchProfileInfoCubit>().fetchProfileInfo(),
      context.read<TodaySchedualCubit>().fetchTodaySchedual(),
      context.read<TeacherClassesCubit>().fetchTeacherClasses(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: kprimeryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بنر الترحيب العصري (Hero Card)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kDarkPrimaryColor, kprimeryColor],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: kprimeryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -2,
                    left: -6,
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: kseconderyColor.withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -35,
                    right: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: kwhiteColor.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  BlocBuilder<FetchProfileInfoCubit, FetchProfileInfoState>(
                    builder: (context, state) {
                      if (state is FetchProfileInfoLoading) {
                        return const SizedBox(
                          height: 30,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: kwhiteColor,
                            ),
                          ),
                        );
                      }

                      String teacherName = '...';
                      if (state is FetchProfileInfoSuccess) {
                        final person =
                            state.profile.teacher?.employee?.user?.person;
                        final fn = person?.firstName ?? '';
                        final ln = person?.lastName ?? '';
                        teacherName = '$fn $ln'.trim();
                        if (teacherName.isEmpty) teacherName = 'مدرس';
                      } else if (state is FetchProfileInfoFailure) {
                        teacherName = 'زائر';
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RichText(
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                text: 'مرحباً بك مجدداً،\n',
                                style: Styles.textStyle14.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: kwhiteColor.withOpacity(0.8),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'أ. $teacherName',
                                    style: Styles.textStyle17.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: kwhiteColor,
                                      fontSize: 19,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: kwhiteColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: kwhiteColor.withOpacity(0.25),
                              ),
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: kseconderyColor,
                              size: 20,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const TeacherHomeDate(
              isInteractive: false,
              showWorkDaysOnly: false,
            ),
            const SizedBox(height: 16),

            // قسم الكروت (حصص اليوم + شعبك)
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<TodaySchedualCubit, TodaySchedualState>(
                    builder: (context, state) {
                      if (state is TodaySchedualLoading) {
                        return const SizedBox(
                          height: 90,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      } else if (state is TodaySchedualFailure) {
                        return _buildMiniErrorCard(
                          onRetry: () => context
                              .read<TodaySchedualCubit>()
                              .fetchTodaySchedual(),
                        );
                      } else if (state is TodaySchedualSuccess) {
                        return HomeLessonsCard(
                          lessonsCount: state.todaySchedual.length,
                        );
                      }
                      return const HomeLessonsCard(lessonsCount: 0);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocBuilder<
                    TeacherClassesCubit,
                    TeacherClassesState
                  >(
                    builder: (context, state) {
                      if (state is TeacherClassesLoading) {
                        return const SizedBox(
                          height: 90,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      } else if (state is TeacherClassesFailure) {
                        return _buildMiniErrorCard(
                          onRetry: () => context
                              .read<TeacherClassesCubit>()
                              .fetchTeacherClasses(),
                        );
                      } else if (state is TeacherClassesSuccess) {
                        final sections = state.teacherClasses.sections;
                        final count =
                            (sections?.classA?.length ?? 0) +
                            (sections?.classB?.length ?? 0);
                        return HomeSectionsCard(sectionsCount: count);
                      }
                      return const HomeSectionsCard(sectionsCount: 0);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const QuickActions(),
            const SizedBox(height: 20),

            // قسم جدول حصص اليوم
            BlocBuilder<TodaySchedualCubit, TodaySchedualState>(
              builder: (context, state) {
                if (state is TodaySchedualLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 36.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is TodaySchedualFailure) {
                  return CustomErrorWidget(
                    title: 'فشل تحميل الجدول اليومي',
                    errorMessage: state.errMassage,
                    onRetry: () =>
                        context.read<TodaySchedualCubit>().fetchTodaySchedual(),
                  );
                } else if (state is TodaySchedualSuccess) {
                  return TodaySchedual(lessons: state.todaySchedual);
                }
                return const TodaySchedual(lessons: []);
              },
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildMiniErrorCard({required VoidCallback onRetry}) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 22,
          ),
          const SizedBox(height: 2),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(
                color: kprimeryColor,
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
