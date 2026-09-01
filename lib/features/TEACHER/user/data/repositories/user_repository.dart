import 'package:dartz/dartz.dart';
import 'package:schooly/core/errors/failure.dart';

import 'package:schooly/features/TEACHER/user/data/datasource/user_remote_data_source.dart';
import 'package:schooly/features/TEACHER/user/data/models/user_model.dart';

class UserRepository {
  final UserRemoteDataSource remote;

  UserRepository(this.remote);

  Future<Either<Failure, UserModel>> getUser(String token) async {
    final result = await remote.getUser(token);
    return result.map((data) => UserModel.fromJson(data));
  }

  Future<Either<Failure, UserModel>> updateUser(
    String token,
    Map<String, dynamic> data,
  ) async {
    final result = await remote.updateUser(token, data);
    return result.map((response) => UserModel.fromJson(response));
  }
}
