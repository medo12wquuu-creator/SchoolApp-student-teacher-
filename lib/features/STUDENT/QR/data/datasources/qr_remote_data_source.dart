import 'package:dio/dio.dart';
import '../models/qr_response.dart';

class QrRemoteDataSource {
  final Dio dio;
  QrRemoteDataSource(this.dio);

  Future<QrResponse> sendQrData(String qrContent) async {
    final response = await dio.post(
      "https://your-backend.com/api/qr",
      data: {"qr_code": qrContent},
    );
    return QrResponse.fromJson(response.data);
  }
}
