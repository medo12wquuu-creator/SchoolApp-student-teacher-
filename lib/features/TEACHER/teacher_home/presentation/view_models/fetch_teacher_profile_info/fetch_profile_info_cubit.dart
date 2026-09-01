import 'package:bloc/bloc.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/fetch_teacher_profile_model/fetch_teacher_profile_model.dart';
 import 'package:schooly/features/TEACHER/teacher_home/data/repos/teacher_home_repo.dart';

part 'fetch_profile_info_state.dart';

class FetchProfileInfoCubit extends Cubit<FetchProfileInfoState> {
  final TeacherHomeRepo teacherHomeRepo;
  FetchProfileInfoCubit(this.teacherHomeRepo)
    : super(FetchProfileInfoInitial());

  Future<void> fetchProfileInfo() async {
    emit(FetchProfileInfoLoading());
    try {
      var response = await teacherHomeRepo.fetchProfileInfo();
      response.fold(
        (failure) => emit(FetchProfileInfoFailure(failure.errMassage)),
        (profile) => emit(FetchProfileInfoSuccess(profile: profile)),
      );
    } catch (e) {
      emit(FetchProfileInfoFailure(e.toString()));
    }
  }
}
