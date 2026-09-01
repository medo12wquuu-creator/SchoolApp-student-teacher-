import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../student_user/presentation/view_models/user_cubit.dart';
import '../../data/repository/exam_review_repository.dart';
import 'exam_review_state.dart';

class ExamReviewCubit extends Cubit<ExamReviewState> {
  final ExamReviewRepository repo;
  final UserCubit userCubit;
  final int attemptId;

  ExamReviewCubit(this.repo, this.userCubit, this.attemptId)
    : super(const ExamReviewState());

  Future<void> getResult() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final token = userCubit.token ?? '';
      final data = await repo.getResult(token, attemptId);
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, result: data));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
