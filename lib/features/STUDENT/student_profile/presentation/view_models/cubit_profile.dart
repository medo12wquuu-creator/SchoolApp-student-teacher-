import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/student_profile/data/models/student_profile_model.dart';
import 'package:schooly/features/STUDENT/student_profile/data/repositories/student_profile_repository.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import 'state_profile.dart';

class StudentProfileCubit extends Cubit<StudentProfileState> {
  final StudentProfileRepository repository;
  final UserCubit userCubit;

  StudentProfileCubit(this.repository, this.userCubit)
    : super(StudentProfileInitial());

  StudentProfileModel? profile;

  Future<void> updateProfile(Map<String, dynamic> body) async {
    emit(StudentProfileUpdating());

    try {
      final updatedProfile = await repository.updateProfile(body);
      if (isClosed) return;
      profile = updatedProfile;
      emit(StudentProfileUpdated(updatedProfile));
    } catch (_) {
      if (isClosed) return;
      emit(StudentProfileError('فشلت تحديث بيانات الملف الشخصي للطالب.'));
    }
  }

  Future<void> loadProfile() async {
    emit(StudentProfileLoading());

    try {
      final token = userCubit.token ?? '';
      final results = await Future.wait<dynamic>([
        repository.getProfile(token),
        Future.delayed(const Duration(seconds: 4)),
      ]);
      if (isClosed) return;
      profile = results[0] as StudentProfileModel;
      emit(StudentProfileLoaded(profile!));
    } catch (_) {
      await Future.delayed(const Duration(seconds: 4));
      if (isClosed) return;
      emit(StudentProfileError('فشلت تحميل بيانات الملف الشخصي للطالب.'));
    }
  }

  Future<void> refreshProfile() async {
    if (!isClosed) emit(StudentProfileLoading());

    try {
      final token = userCubit.token ?? '';
      final results = await Future.wait<dynamic>([
        repository.getProfile(token),
        Future.delayed(const Duration(seconds: 3)),
      ]);
      if (isClosed) return;
      profile = results[0] as StudentProfileModel;
      emit(StudentProfileLoaded(profile!));
    } catch (_) {
      await Future.delayed(const Duration(seconds: 3));
      if (isClosed) return;
      emit(StudentProfileError('فشلت تحديث بيانات الملف الشخصي للطالب.'));
    }
  }
}
