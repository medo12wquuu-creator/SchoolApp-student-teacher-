import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../student_user/presentation/view_models/user_cubit.dart';
import '../../data/repositories/tasks_repository.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TasksRepository repo;
  final UserCubit userCubit;

  TasksCubit(this.repo, this.userCubit) : super(const TasksState());

  Future<void> getTasks() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final token = userCubit.token ?? '';
      if (isClosed) return; // ← أضف هذا

      final data = await repo.getTasks(token);
      emit(state.copyWith(isLoading: false, tasks: data));
    } catch (e) {
      if (isClosed) return; // ← أضف هذا

      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
