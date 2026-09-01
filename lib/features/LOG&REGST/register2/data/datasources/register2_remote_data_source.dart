import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:schooly/core/constants/api_constants.dart';
import '../models/classroom_model.dart';

class Register2RemoteDataSource {
  final Dio dio;

  Register2RemoteDataSource(this.dio);

  Future<List<ClassroomModel>> getClasses() async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}${EndPoints.classroom}',
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final classroomList = data['classroom'] as List? ?? const [];

        return classroomList
            .map(
              (item) =>
                  ClassroomModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
      }

      return [];
    } catch (e) {
      print('❌ GET CLASSES ERROR: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> register({
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
    final formattedBirthdate = DateFormat('yyyy-MM-dd').format(birthdate);

    final formData = FormData.fromMap({
      "first_name": firstName,
      "last_name": lastName,
      "middle_name": fatherName,
      "mother_name": motherName,
      "classWanted": classWanted,
      "birthdate": formattedBirthdate,
      "email": email,
      "phone_number": phone,
      "password": password,
      "personal_photo": await MultipartFile.fromFile(profileImage.path),
      "id_photo": await MultipartFile.fromFile(id1.path),
      "last_class_certification": await MultipartFile.fromFile(
        last_class_certification.path,
      ),
    });
    print("===== FORM DATA SENT TO BACKEND =====");
    for (var field in formData.fields) {
      print("FIELD: ${field.key} = ${field.value}");
    }
    for (var file in formData.files) {
      print("FILE: ${file.key} = ${file.value.filename}");
    }
    print("======================================");
    try {
      final response = await dio.post(
        ApiConstants.baseUrl + EndPoints.register2,
        data: formData,
      );

      print("📥 RESPONSE RECEIVED:");
      print("➡️ STATUS CODE: ${response.statusCode}");
      print("➡️ RAW DATA: ${response.data}");
      print("➡️ STATUS MESSAGE: ${response.statusMessage}");

      String message = response.statusMessage ?? '';
      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('message')) {
        message = response.data['message']?.toString() ?? message;
      }

      print("📌 FINAL MESSAGE: $message");
      print("📌 FINAL CODE: ${response.data["user"]["code"] ?? ''}");

      return {
        "statusCode": response.statusCode,
        "message": response.data["message"] ?? "",
      };
    } catch (e) {
      print("❌ DIO ERROR:");
      print(e);

      return {"statusCode": 0, "message": "Connection failed: $e"};
    }
  }
}
