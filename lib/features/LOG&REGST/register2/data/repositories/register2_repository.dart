import 'dart:io';
import '../datasources/register2_remote_data_source.dart';
import '../models/classroom_model.dart';
import '../models/register2_response.dart';

class Register2Repository {
  final Register2RemoteDataSource remote;

  Register2Repository(this.remote);

  Future<List<ClassroomModel>> getClasses() async {
    return remote.getClasses();
  }

  Future<Register2Response> registerUser({
    required File profileImage,
    required File id1,
    required File last_class_certification,
    required String firstName,
    required String classWanted,
    required String lastName,
    required String fatherName,
    required String motherName,
    required DateTime birthdate,
    required String email,
    required String phone,
    required String password,
  }) async {
    final result = await remote.register(
      profileImage: profileImage,
      id1: id1,
      last_class_certification: last_class_certification,
      firstName: firstName,
      lastName: lastName,
      classWanted: classWanted,
      fatherName: fatherName,
      motherName: motherName,
      birthdate: birthdate,
      email: email,
      phone: phone,
      password: password,
    );

    return Register2Response.fromJson(result);
  }
}
