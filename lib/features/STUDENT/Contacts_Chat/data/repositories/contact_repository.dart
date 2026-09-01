import 'dart:io';

import 'package:dio/dio.dart';

import '../datasource/contact_remote_data_source.dart';
import '../models/contact_model.dart';

class ContactRepository {
  final ContactRemoteDataSource remote;

  ContactRepository(this.remote);

  Future<List<ContactModel>> getContacts(String token) async {
    final data = await remote.getContacts(token);
    final models = data
        .map((e) => ContactModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return Future.wait(
      models.map((model) async {
        final file = await _downloadImage(model.photoUrl);
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
        '${dir.path}/contact_${DateTime.now().microsecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(response.data ?? const []);
      return file;
    } catch (_) {
      return null;
    }
  }
}
