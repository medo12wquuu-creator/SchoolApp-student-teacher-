import 'package:bloc/bloc.dart';
 import 'package:schooly/features/TEACHER/teacher_profile/data/repo/teacher_profile_repo.dart';

part 'send_new_password_state.dart';

class SendNewPasswordCubit extends Cubit<SendNewPasswordState> {
  final TeacherProfileRepo teacherProfileRepo;
  SendNewPasswordCubit(this.teacherProfileRepo)
    : super(SendNewPasswordInitial());

  Future<void> sendNewPassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    emit(SendNewPasswordLoading());
    try {
      var response = await teacherProfileRepo.sendNewPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      response.fold(
        (failure) => emit(SendNewPasswordFailure(failure.errMassage)),
        (model) => emit(SendNewPasswordSuccess(model.message)),
      );
    } catch (e) {
      emit(SendNewPasswordFailure(e.toString()));
    }
  }
}
