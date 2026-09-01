import 'package:schooly/features/STUDENT/QR/data/datasources/qr_remote_data_source.dart';

import '../models/qr_response.dart';

class QrRepository {
  final QrRemoteDataSource remote;
  QrRepository(this.remote);

  Future<QrResponse> processQr(String content) async {
    return await remote.sendQrData(content);
  }
}
