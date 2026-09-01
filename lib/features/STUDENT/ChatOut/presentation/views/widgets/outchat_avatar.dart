import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schooly/core/constants/api_constants.dart';

class OutChatAvatar extends StatelessWidget {
  final String imageUrl;
  final File? file;
  final double size;

  const OutChatAvatar({
    super.key,
    required this.imageUrl,
    this.file,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    if (file != null) {
      provider = FileImage(file!);
    } else {
      final url = _fullUrl;
      if (url.isNotEmpty) provider = NetworkImage(url);
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: const Color.fromARGB(255, 219, 144, 249),
      backgroundImage: provider,
      child: provider == null
          ? Icon(
              Icons.person,
              size: size / 2,
              color: const Color.fromARGB(255, 182, 31, 208),
            )
          : null,
    );
  }

  String get _fullUrl {
    if (imageUrl.isEmpty) return '';
    final origin = ApiConstants.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    if (imageUrl.startsWith('http')) {
      return imageUrl.replaceFirst(RegExp(r'^https?://[^/]+'), origin);
    }
    if (imageUrl.startsWith('/')) return '$origin$imageUrl';
    return 'storage/$imageUrl';
  }
}
