import 'dart:io';
import 'package:bloc/bloc.dart';
 import 'package:schooly/features/TEACHER/teacher_profile/data/repo/teacher_profile_repo.dart';

part 'send_teacher_profile_info_state.dart';

class SendTeacherProfileInfoCubit extends Cubit<SendTeacherProfileInfoState> {
  final TeacherProfileRepo teacherProfileRepo;
  SendTeacherProfileInfoCubit(this.teacherProfileRepo)
    : super(SendTeacherProfileInfoInitial());

  Future<void> sendProfileInfo({
    required String phone,
    required String email,
    File? photoFile,
  }) async {
    emit(SendTeacherProfileInfoLoading());
    try {
      var response = await teacherProfileRepo.sendProfileInfo(
        phone: phone,
        email: email,
        photoFile: photoFile,
      );
      response.fold(
        (failure) => emit(SendTeacherProfileInfoFailure(failure.errMassage)),
        (model) => emit(SendTeacherProfileInfoSuccess(model.message)),
      );
    } catch (e) {
      emit(SendTeacherProfileInfoFailure(e.toString()));
    }
  }
}
