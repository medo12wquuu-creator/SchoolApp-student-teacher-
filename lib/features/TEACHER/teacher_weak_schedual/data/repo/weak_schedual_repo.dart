import 'package:dartz/dartz.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/data/models/weak_schedual_model/weak_schedual_model.dart';

abstract class WeakSchedualRepo {
  Future<Either<Failure, WeakSchedualModel>> fetchWeakSchedual();
}
