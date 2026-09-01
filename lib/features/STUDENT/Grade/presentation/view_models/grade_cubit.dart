import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/Grade/data/repos/grade_repository.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import 'grade.state.dart';

class GradeCubit extends Cubit<GradeState> {
  final GradeRepository repository;
  final UserCubit userCubit;

  GradeCubit(this.repository, this.userCubit) : super(GradeInitial());

  Future<void> loadGrades() async {
    if (!isClosed) emit(GradeLoading());
    print('========== GradeCubit.loadGrades ==========');
    try {
      final token = userCubit.token ?? '';
      final data = await repository.getGrades(token);
      print('Semesters count: ${data.semesters.length}');
      if (!isClosed) emit(GradeLoaded(data)); // افتراضياً الفصل الأول (index 0)
    } catch (e) {
      print('GradeCubit error: $e');
      if (!isClosed) emit(GradeError(e.toString()));
    }
  }

  void selectSemester(int index) {
    final current = state;
    if (current is GradeLoaded) {
      if (!isClosed) {
        emit(GradeLoaded(current.data, selectedSemesterIndex: index));
      }
    }
  }
}
