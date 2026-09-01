import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_state.dart';
import '../../data/repositories/home_repository.dart';
import '../../../student_user/presentation/view_models/user_cubit.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repo;
  final UserCubit userCubit;

  HomeCubit(this.repo, this.userCubit) : super(const HomeState());

  // ---------------------------------------------------------
  // 1) Attendance
  // ---------------------------------------------------------
  Future<void> getAttendance() async {
    emit(
      state.copyWith(
        attendanceLoading: true,
        attendanceError: null,
        errorMessage: null,
      ),
    );

    try {
      final token = userCubit.token ?? '';
      final data = await repo.getAttendanceAbsences(token);
      emit(state.copyWith(attendanceLoading: false, attendance: data));
    } catch (e) {
      emit(
        state.copyWith(attendanceLoading: false, attendanceError: e.toString()),
      );
    }
  }

  // ---------------------------------------------------------
  // 2) Events
  // ---------------------------------------------------------
  Future<void> getEvents() async {
    emit(
      state.copyWith(
        eventsLoading: true,
        eventsError: null,
        errorMessage: null,
      ),
    );

    try {
      final token = userCubit.token ?? '';
      final data = await repo.getEvents(token);
      emit(state.copyWith(eventsLoading: false, events: data));
    } catch (e) {
      emit(state.copyWith(eventsLoading: false, eventsError: e.toString()));
    }
  }

  // ---------------------------------------------------------
  // 3) Tasks
  // ---------------------------------------------------------
  Future<void> getTasks() async {
    emit(
      state.copyWith(tasksLoading: true, tasksError: null, errorMessage: null),
    );

    try {
      final token = userCubit.token ?? '';
      final data = await repo.getTasks(token);
      emit(state.copyWith(tasksLoading: false, tasks: data));
    } catch (e) {
      emit(state.copyWith(tasksLoading: false, tasksError: e.toString()));
    }
  }

  // ---------------------------------------------------------
  // 4) Schedule
  // ---------------------------------------------------------
  Future<void> getSchedule() async {
    emit(
      state.copyWith(
        scheduleLoading: true,
        scheduleError: null,
        errorMessage: null,
      ),
    );

    try {
      final token = userCubit.token ?? '';
      final data = await repo.getSchedule(token);
      emit(state.copyWith(scheduleLoading: false, schedule: data));
    } catch (e) {
      emit(state.copyWith(scheduleLoading: false, scheduleError: e.toString()));
    }
  }

  // ---------------------------------------------------------
  // 5) Register for an event
  // ---------------------------------------------------------
  Future<void> registerCompetition(int eventId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final token = userCubit.token ?? '';
      final message = await repo.registerCompetition(eventId, token);

      // أضف الحدث إلى قائمة المسجلين واحفظه محلياً (يبقى بعد إغلاق التطبيق)
      final newSet = {...state.registeredEvents, eventId};
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'registered_events',
        newSet.map((e) => e.toString()).toList(),
      );

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: message,
          registeredEvents: newSet,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ---------------------------------------------------------
  // حمل الأحداث المسجلة مسبقاً من التخزين
  // ---------------------------------------------------------
  Future<void> _loadRegisteredEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('registered_events') ?? [];

    emit(
      state.copyWith(
        registeredEvents: ids
            .where((e) => int.tryParse(e) != null)
            .map(int.parse)
            .toSet(),
      ),
    );
  }

  // ---------------------------------------------------------
  // 🚀 Load all APIs at once
  // ---------------------------------------------------------
  Future<void> loadHomeData() async {
    await _loadRegisteredEvents();
    await Future.wait([
      getAttendance(),
      getEvents(),
      getTasks(),
      getSchedule(),
    ]);
  }
}
