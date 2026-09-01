import 'package:schooly/features/LOG&REGST/register/data/datasources/register_remote_data_source.dart';
import 'package:schooly/features/LOG&REGST/register/data/models/register_response.dart';

class RegisterRepository {
  final RegisterRemoteDataSource remote;

  RegisterRepository(this.remote);

  Future<RegisterResponse> register({
    // required String firstName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final result = await remote.register({
      // "username": firstName,
      "email": email,
      "phone_number": phone,
      "password": password,
    });

    return RegisterResponse.fromJson(result);
  }
}
