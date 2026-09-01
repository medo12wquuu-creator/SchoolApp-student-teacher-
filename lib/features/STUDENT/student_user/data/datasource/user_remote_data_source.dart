import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource(this.dio);

  // -----------------------------
  // GET USER DATA
  // -----------------------------
  Future<Map<String, dynamic>> getUser(String token) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${EndPoints.getUser}/$token',
    );

    return response.data;
  }

  // -----------------------------
  // UPDATE USER DATA
  // -----------------------------
  Future<Map<String, dynamic>> updateUser(
    String token,
    Map<String, dynamic> body,
  ) async {
    final response = await dio.put(
      ApiConstants.baseUrl + EndPoints.updateUser,
      data: body,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );

    return response.data;
  }
}
