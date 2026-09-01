import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_profile/data/models/edit_password_model.dart';
import 'package:schooly/features/TEACHER/teacher_profile/data/models/send_profile_info_model.dart';
import 'package:schooly/features/TEACHER/teacher_profile/data/repo/teacher_profile_repo.dart';

class TeacherProfileRepoImp implements TeacherProfileRepo {
  final ApiService apiService;
  TeacherProfileRepoImp(this.apiService);

  @override
  Future<Either<Failure, SendProfileInfoModel>> sendProfileInfo({
    required String phone,
    required String email,
    File? photoFile,
  }) async {
    try {
      // 🟢 توحيد الطلب باستخدام الـ Endpoint والـ Multipart المحدد من قبل السيرفر
      final response = await apiService.postMultipart(
        endPoint: '/updateTeacherProfile',
        fields: {'phone_number': phone, 'email': email, '_method': 'POST'},
        fileField: 'personal_photo',
        filePath: photoFile?.path,
      );

      return right(SendProfileInfoModel.fromJson(response));
    } on DioException catch (e) {
      // 🔍 طباعة الاستجابة بالتفصيل عند حدوث خطأ Validation (422) لمعرفة السبب
      if (e.response != null && e.response?.statusCode == 422) {
        print("======== 422 VALIDATION ERROR ========");
        print(e.response?.data);
        print("======================================");
      }
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure("Parsing Error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, EditPasswordModel>> sendNewPassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      var response = await apiService.post(
        endPoint: '/changePassword',
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );
      return right(EditPasswordModel.fromJson(response));
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 422) {
        return left(ServerFailure('كلمة المرور القديمة غير صحيحة'));
      }
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure("Parsing Error: ${e.toString()}"));
    }
  }
}
