import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_profile/data/models/edit_password_model.dart';
import 'package:schooly/features/TEACHER/teacher_profile/data/models/send_profile_info_model.dart';

abstract class TeacherProfileRepo {
  Future<Either<Failure, SendProfileInfoModel>> sendProfileInfo({
    required String phone,
    required String email,
    File? photoFile,
  });
  Future<Either<Failure, EditPasswordModel>> sendNewPassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}
