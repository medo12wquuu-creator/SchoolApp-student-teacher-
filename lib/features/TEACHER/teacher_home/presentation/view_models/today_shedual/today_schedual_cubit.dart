import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/today_schedual_model/today_schedual_model.dart';
  import 'package:schooly/features/TEACHER/teacher_home/data/repos/teacher_home_repo.dart';

part 'today_schedual_state.dart';

class TodaySchedualCubit extends Cubit<TodaySchedualState> {
  TodaySchedualCubit(this.teacherHomeRepo) : super(TodaySchedualInitial());

  final TeacherHomeRepo teacherHomeRepo;

  Future<void> fetchTodaySchedual() async {
    emit(TodaySchedualLoading());
    try {
      var response = await teacherHomeRepo.fetchTodaySchedual();

      response.fold(
        (failure) {
          emit(TodaySchedualFailure(failure.errMassage));
        },
        (allLessons) {
          final hasDayOfWeek = allLessons.any((l) => l.dayOfWeek != null);

          List<TodaySchedualModel> todayLessons;
          if (hasDayOfWeek) {
            // DateTime.weekday: Mon=1..Sun=7
            // Backend dayOfWeek: Sun=0, Mon=1..Sat=6
            // weekday % 7 -> Sun 7%7=0, Mon 1%7=1 .. Sat 6%7=6
            final todayBackend = DateTime.now().weekday % 7;
            todayLessons = allLessons
                .where((l) => l.dayOfWeek == todayBackend)
                .toList();
          } else {
            todayLessons = allLessons;
          }
          emit(TodaySchedualSuccess(todaySchedual: todayLessons));
        },
      );
    } catch (e) {
      emit(TodaySchedualFailure(e.toString()));
    }
  }
}
