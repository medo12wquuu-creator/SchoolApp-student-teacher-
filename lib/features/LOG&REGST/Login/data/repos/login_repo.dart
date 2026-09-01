import 'package:dartz/dartz.dart';
import 'package:schooly/core/errors/failuree.dart';
import 'package:schooly/features/LOG&REGST/Login/data/models/login_model/login_model.dart';

abstract class LoginRepo {
  Future<Either<Failure, LoginModel>> sendLoginDetails({
    required String email,
    required String password,
  });
}
