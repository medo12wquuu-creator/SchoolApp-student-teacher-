// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../student_user/presentation/view_models/user_cubit.dart';
// import '../../data/repository/out_quiz_repository.dart';
// import 'out_quiz_state.dart';

// class OutQuizCubit extends Cubit<OutQuizState> {
//   final OutQuizRepository repo;
//   final UserCubit userCubit;

//   OutQuizCubit(this.repo, this.userCubit) : super(const OutQuizState());

//   Future<void> getExams() async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));

//     try {
//       final token = userCubit.token ?? '';
//       final data = await repo.getExams(token);
//       emit(state.copyWith(isLoading: false, quizzes: data));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
//     }
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/services/reverb_service.dart';
import '../../../student_user/presentation/view_models/user_cubit.dart';
import '../../data/repository/out_quiz_repository.dart';
import 'out_quiz_state.dart';

class OutQuizCubit extends Cubit<OutQuizState> {
  final OutQuizRepository repo;
  final UserCubit userCubit;
  final ReverbService reverb;

  OutQuizCubit(this.repo, this.userCubit, this.reverb)
    : super(const OutQuizState());

  Future<void> getExams() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final token = userCubit.token ?? '';
      final data = await repo.getExams(token);
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, quizzes: data));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// الاستماع الواحد لقناة الكويزات — كل حدث يحدّث القائمة بصمت
  void listenToQuizEvents() {
    final userId = userCubit.currentUser?.id ?? 0;
    if (userId == 0) return;

    reverb.listenToExams(
      userId: userId,
      onExamPublished: (_) => _refreshSilently(),
      onExamClosed: (_) => _refreshSilently(),
      onExamTimeEnded: (_) => _refreshSilently(),
      onExamResultReady: (_) => _refreshSilently(),
      onExamCompleted: (_) => _refreshSilently(),
      onExamAvailable: (_) => _refreshSilently(),
    );
  }

  /// الـ payload مصغّر → نسحب القائمة من الـ API بدون تغيير isLoading
  Future<void> _refreshSilently() async {
    try {
      final token = userCubit.token ?? '';
      final data = await repo.getExams(token);
      if (isClosed) return;
      emit(state.copyWith(quizzes: data));
    } catch (_) {}
  }
}
