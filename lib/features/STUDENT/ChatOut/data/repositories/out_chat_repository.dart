import 'dart:io';

import 'package:dio/dio.dart';
import '../datasource/out_chat_remote_data_source.dart';
import '../models/outchat_model.dart';

class OutChatRepository {
  final OutChatRemoteDataSource remote;

  OutChatRepository(this.remote);

  Future<List<OutChatModel>> getConversations(String token) async {
    final data = await remote.getConversations(token);

    final models = data
        .map((e) => OutChatModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return Future.wait(
      models.map((model) async {
        final file = await _downloadImage(model.otherUserImageUrl);
        return model.copyWith(personalPhotoFile: file);
      }),
    );
  }

  Future<File?> _downloadImage(String url) async {
    if (url.isEmpty) return null;
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final dir = Directory.systemTemp;
      final file = File(
        '${dir.path}/outchat_${DateTime.now().microsecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(response.data ?? const []);
      return file;
    } catch (_) {
      return null;
    }
  }
}
