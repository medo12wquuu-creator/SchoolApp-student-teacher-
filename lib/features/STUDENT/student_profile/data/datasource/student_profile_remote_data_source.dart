import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';

class StudentProfileRemoteDataSource {
  final Dio dio;

  StudentProfileRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getStudentProfile(String token) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${EndPoints.getUser}',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }

  Future<File?> downloadFile(String url) async {
    try {
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      final data = response.data;
      final bytes = data is List<int>
          ? data
          : data is Uint8List
          ? data.toList()
          : null;
      if (bytes == null) return null;

      final filename = Uri.parse(url).pathSegments.isNotEmpty
          ? Uri.parse(url).pathSegments.last
          : 'image_${DateTime.now().millisecondsSinceEpoch}';

      final file = File('${Directory.systemTemp.path}/$filename');
      await file.writeAsBytes(bytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> updateStudentProfile(
    Map<String, dynamic> body,
  ) async {
    final response = await dio.put(
      ApiConstants.baseUrl + EndPoints.updateUser,
      data: body,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    return response.data;
  }
}
