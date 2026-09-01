import 'package:dartz/dartz.dart';
   import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/fetch_teacher_profile_model/fetch_teacher_profile_model.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/today_schedual_model/today_schedual_model.dart';

abstract class TeacherHomeRepo {
  Future<Either<Failure, String>> fetchTeacherName();
  Future<Either<Failure, List<TodaySchedualModel>>> fetchTodaySchedual();
  Future<Either<Failure, FetchTeacherProfileModel>> fetchProfileInfo();
}
