import 'package:schooly/features/STUDENT/student_profile/data/datasource/student_profile_remote_data_source.dart';

import '../models/student_profile_model.dart';
import 'package:schooly/core/constants/api_constants.dart';

class StudentProfileRepository {
  final StudentProfileRemoteDataSource remote;

  StudentProfileRepository(this.remote);

  Future<StudentProfileModel> getProfile(String token) async {
    final data = await remote.getStudentProfile(token);
    final userJson = data['user'] as Map<String, dynamic>? ?? data;

    String? photoUrl;
    final person = userJson['person'] is Map
        ? Map<String, dynamic>.from(userJson['person'])
        : null;
    final personalPhotoValue =
        person?['personal_photo'] ?? person?['personalPhoto'];
    if (personalPhotoValue != null) {
      final filename = personalPhotoValue.toString();
      if (filename.startsWith('http')) {
        photoUrl = filename;
      } else if (filename.startsWith('/')) {
        photoUrl = ApiConstants.baseUrl + filename;
      } else {
        photoUrl = '${ApiConstants.baseUrl}/storage/$filename';
      }
    }

    return StudentProfileModel.fromJson(userJson, downloadedPhotoUrl: photoUrl);
  }

  Future<StudentProfileModel> updateProfile(Map<String, dynamic> body) async {
    final data = await remote.updateStudentProfile(body);
    final userJson = data['user'] as Map<String, dynamic>? ?? data;

    String? photoUrl;
    final person = userJson['person'] is Map
        ? Map<String, dynamic>.from(userJson['person'])
        : null;
    final personalPhotoValue =
        person?['personal_photo'] ?? person?['personalPhoto'];
    if (personalPhotoValue != null) {
      final filename = personalPhotoValue.toString();
      if (filename.startsWith('http')) {
        photoUrl = filename;
      } else if (filename.startsWith('/')) {
        photoUrl = ApiConstants.baseUrl + filename;
      } else {
        photoUrl = '${ApiConstants.baseUrl}/storage/$filename';
      }
    }

    return StudentProfileModel.fromJson(userJson, downloadedPhotoUrl: photoUrl);
  }
}
