import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/widgets/teacher_home_date.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/data/models/weak_schedual_model/lesson.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/presentation/view_models/weak_schedual/weak_schedual_cubit.dart';

class TeacherWeakSchedual extends StatefulWidget {
  const TeacherWeakSchedual({super.key});

  @override
  State<TeacherWeakSchedual> createState() => _TeacherWeakSchedualState();
}

class _TeacherWeakSchedualState extends State<TeacherWeakSchedual> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getIt<WeakSchedualCubit>().fetchSchedual();
  }

  int _backendDayOfWeek(DateTime date) {
    // DateTime.weekday: Mon=1 .. Sun=7
    // Backend: 0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat
    return date.weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<WeakSchedualCubit>(),
      child: Container(
        color: kbackgroundColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              TeacherHomeDate(
                showWorkDaysOnly: true,
                isInteractive: true,
                selectedDate: _selectedDate,
                onDateSelected: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<WeakSchedualCubit, WeakSchedualState>(
                builder: (context, state) {
                  if (state is WeakSchedualLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is WeakSchedualFailure) {
                    return Center(
                      child: Text(
                        state.errMassage,
                        style: const TextStyle(color: kRedColor),
                      ),
                    );
                  }
                  if (state is WeakSchedualSuccess) {
                    final dayLessons =
                        state.lessons
                            .where(
                              (l) =>
                                  l.dayOfWeek ==
                                  _backendDayOfWeek(_selectedDate),
                            )
                            .toList()
                          ..sort((a, b) {
                            final aPeriod = a.timeSlot?.periodNumber ?? 0;
                            final bPeriod = b.timeSlot?.periodNumber ?? 0;
                            return aPeriod.compareTo(bPeriod);
                          });
                    if (dayLessons.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('لا توجد حصص لهذا اليوم'),
                        ),
                      );
                    }
                    return TimelineScheduleList(lessons: dayLessons);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimelineScheduleList extends StatelessWidget {
  final List<Lesson> lessons;

  const TimelineScheduleList({super.key, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 30,
          bottom: 30,
          right: 22,
          child: Container(width: 2, color: ktextColor.withOpacity(0.15)),
        ),
        Column(
          children: lessons.expand((lesson) {
            final items = <Widget>[];
            items.add(_buildLessonItem(lesson));
            items.add(const SizedBox(height: 16));
            return items;
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLessonItem(Lesson lesson) {
    final subjectName = lesson.subject?.name ?? 'بدون مادة';
    final sectionName = lesson.section?.name ?? '';
    final sectionClass = lesson.section?.classroom?.name ?? '';
    final title = '$subjectName - $sectionClass $sectionName'.trim();
    final startTime = lesson.timeSlot?.startTime ?? '';
    final endTime = lesson.timeSlot?.endTime ?? '';
    final time = '$startTime - $endTime';
    final isBreak = lesson.timeSlot?.isBreak == 1;

    if (isBreak) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: Color(0xFF8D6E63),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFECB3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_cafe_outlined,
                        color: Color(0xFF8D6E63),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'استراحة / فسحة',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8D6E63),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final colors = [
      kprimeryColor,
      kadditionalColor,
      kseconderyColor,
      const Color(0xFF9C27B0),
      const Color(0xFFFF5722),
    ];
    final colorIndex = (lesson.id ?? 0) % colors.length;
    final color = colors[colorIndex];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.book_rounded, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: kwhiteColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ktextColor.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: kprimeryColor.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: ktextColor.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: ktextColor.withOpacity(0.6),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                time,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ktextColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 6,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadiusDirectional.only(
                        topEnd: Radius.circular(16),
                        bottomEnd: Radius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
