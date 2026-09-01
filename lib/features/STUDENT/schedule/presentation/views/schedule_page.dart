import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:schooly/core/errors/failed_to_load_widget.dart';
import 'package:schooly/features/STUDENT/schedule/data/datasource/schedule_remote_data_source.dart';
import 'package:schooly/features/STUDENT/schedule/data/repositories/schedule_repository.dart';
import 'package:schooly/features/STUDENT/schedule/presentation/view_models/schedule_cubit.dart';
import 'package:schooly/features/STUDENT/schedule/presentation/view_models/schedule_state.dart';
import 'package:schooly/features/STUDENT/schedule/presentation/views/widget/class_card.dart';
import 'package:schooly/features/STUDENT/schedule/presentation/views/widget/days_row.dart';
import 'package:schooly/features/STUDENT/schedule/presentation/views/widget/header_card.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String selectedDay = 'الأحد';
  late final ScheduleCubit _cubit;

  static const Map<String, int> _dayOfWeek = {
    'الأحد': 0,
    'الاثنين': 1,
    'الثلاثاء': 2,
    'الأربعاء': 3,
    'الخميس': 4,
  };

  int get _selectedDayNumber => _dayOfWeek[selectedDay] ?? 0;

  @override
  void initState() {
    super.initState();
    final userCubit = context.read<UserCubit>();
    _cubit = ScheduleCubit(
      ScheduleRepository(ScheduleRemoteDataSource(Dio())),
      userCubit,
    );
    _cubit.getSchedule(_selectedDayNumber);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onDaySelected(String day) {
    setState(() {
      selectedDay = day;
    });
    _cubit.getSchedule(_selectedDayNumber);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF7F9FC);
    final appBarBg = isDark
        ? const Color(0xFF1A1C1E).withOpacity(0.7)
        : Colors.white.withOpacity(0.7);

    return BlocProvider<ScheduleCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: appBarBg,
          elevation: 0,
          title: const Text(
            'البرنامج الأسبوعي',
            style: TextStyle(
              color: Color(0xFF1565C0),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.calendar_today, color: Color(0xFF1565C0)),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              final firstItem = state.schedule?.isNotEmpty == true
                  ? state.schedule!.first
                  : null;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderCard(
                      semesterName: firstItem?.semesterName ?? 'الفصل',
                      className: firstItem?.classroomName ?? 'الصف',
                      sectionName: firstItem?.sectionName ?? 'الشعبة',
                    ),
                    const SizedBox(height: 24),

                    DaysRow(
                      selectedDay: selectedDay,
                      onDaySelected: _onDaySelected,
                    ),
                    const SizedBox(height: 24),

                    if (state.scheduleLoading)
                      Center(
                        child: Center(
                          child: Lottie.asset(
                            'assets/animation/loading (4).json',
                            width: 120,
                            height: 120,
                          ),
                        ),
                      )
                    // else if (state.scheduleError != null)
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 24),
                    //     child: Text(
                    //       state.scheduleError!,
                    //       style: const TextStyle(color: Colors.red),
                    //     ),
                    //   )
                    else if (state.scheduleError != null)
                      FailedToLoadWidget(
                        itemName: 'البرنامج الأسبوعي❌',
                        onRetry: () => _cubit.getSchedule(_selectedDayNumber),
                      )
                    else if (state.schedule?.isEmpty == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'لا يوجد جدول لهذا اليوم.',
                          style: TextStyle(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.black87,
                          ),
                        ),
                      )
                    else
                      ...state.schedule!.map(
                        (item) => ClassCard(
                          subject: item.subjectName,
                          teacherName: item.teacherName,
                          time: '${item.startTime} - ${item.endTime}',
                          accent: const Color(0xFF2196F3),
                        ),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
