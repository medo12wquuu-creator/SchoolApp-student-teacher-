import 'package:bloc/bloc.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';

part 'take_atendance_state.dart';

class TakeAtendanceCubit extends Cubit<TakeAtendanceState> {
  final ClassDetailsRepo classDetailsRepo;
  TakeAtendanceCubit(this.classDetailsRepo) : super(TakeAtendanceInitial());


  Future<void> submitAttendance({
    required String sectionId,
    required List<Map<String, dynamic>> attendances,
  }) async {
    emit(TakeAtendanceLoading());
    try {
      var response = await classDetailsRepo.takeAttendance(
        sectionId: sectionId,
        attendances: attendances,
      );
      response.fold(
        (failure) => emit(TakeAtendanceFailure(failure.errMassage)),
        (_) => emit(TakeAtendanceSuccess()),
      );
    } catch (e) {
      emit(TakeAtendanceFailure(e.toString()));
    }
  }
}
