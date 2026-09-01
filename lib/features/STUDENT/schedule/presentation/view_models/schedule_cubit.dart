import 'package:flutter_bloc/flutter_bloc.dart';
import 'schedule_state.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../../student_user/presentation/view_models/user_cubit.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository repo;
  final UserCubit userCubit;

  ScheduleCubit(this.repo, this.userCubit) : super(const ScheduleState());

  Future<void> getSchedule(int dayOfWeek) async {
    emit(state.copyWith(scheduleLoading: true, scheduleError: null));

    try {
      final token = userCubit.token ?? '';
      final schedule = await repo.getSchedule(token, dayOfWeek);
      if (isClosed) return;
      emit(state.copyWith(scheduleLoading: false, schedule: schedule));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(scheduleLoading: false, scheduleError: e.toString()));
    }
  }
}
