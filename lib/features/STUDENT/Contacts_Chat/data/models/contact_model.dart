import 'dart:io';

import 'package:schooly/core/constants/api_constants.dart';

class ContactModel {
  final int id;
  final String name;
  final String personalPhoto;
  final int? conversationId;
  final File? personalPhotoFile;

  ContactModel({
    required this.id,
    required this.name,
    required this.personalPhoto,
    required this.conversationId,
    this.personalPhotoFile,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      personalPhoto: json['personal_photo'] as String? ?? '',
      conversationId: json['conversation_id'] as int?,
    );
  }

  ContactModel copyWith({File? personalPhotoFile}) {
    return ContactModel(
      id: id,
      name: name,
      personalPhoto: personalPhoto,
      conversationId: conversationId,
      personalPhotoFile: personalPhotoFile ?? this.personalPhotoFile,
    );
  }

  String get photoUrl {
    if (personalPhoto.isEmpty) return '';
    final origin = ApiConstants.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    if (personalPhoto.startsWith('http')) {
      return personalPhoto.replaceFirst(RegExp(r'^https?://[^/]+'), origin);
    }
    if (personalPhoto.startsWith('/')) return '$origin$personalPhoto';
    return 'storage/$personalPhoto';
  }
}
