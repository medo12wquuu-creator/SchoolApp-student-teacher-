import 'package:dartz/dartz.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/teacher_classes_model/teacher_classes_model.dart';

abstract class ClassesRepo {
  Future<Either<Failure, TeacherClassesModel>> fetchTeacherClasses();
}
