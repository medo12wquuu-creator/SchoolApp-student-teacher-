import 'package:schooly/features/STUDENT/student_user/data/datasource/user_remote_data_source.dart';
import 'package:schooly/features/STUDENT/student_user/data/models/user_model.dart';

class UserRepository {
  final UserRemoteDataSource remote;

  UserRepository(this.remote);

  Future<UserModel> getUser(String token) async {
    final data = await remote.getUser(token);
    return UserModel.fromJson(data["user"]);
  }

  Future<UserModel> updateUser(String token, Map<String, dynamic> body) async {
    final data = await remote.updateUser(token, body);
    return UserModel.fromJson(data["user"]);
  }
}
