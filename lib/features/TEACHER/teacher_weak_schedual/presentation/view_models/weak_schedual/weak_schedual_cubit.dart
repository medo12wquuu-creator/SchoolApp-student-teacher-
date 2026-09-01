import 'package:bloc/bloc.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/data/models/weak_schedual_model/lesson.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/data/repo/weak_schedual_repo.dart';

part 'weak_schedual_state.dart';

class WeakSchedualCubit extends Cubit<WeakSchedualState> {
  final WeakSchedualRepo weakSchedualRepo;
  WeakSchedualCubit(this.weakSchedualRepo) : super(WeakSchedualInitial());

  Future<void> fetchSchedual() async {
    emit(WeakSchedualLoading());
    try {
      var response = await weakSchedualRepo.fetchWeakSchedual();
      response.fold(
        (failure) => emit(WeakSchedualFailure(failure.errMassage)),
        (data) => emit(WeakSchedualSuccess(lessons: data.lessons ?? [])),
      );
    } catch (e) {
      emit(WeakSchedualFailure(e.toString()));
    }
  }
}
