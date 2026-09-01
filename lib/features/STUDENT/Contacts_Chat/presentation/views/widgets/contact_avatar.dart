import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schooly/core/constants/api_constants.dart';

class ContactAvatar extends StatelessWidget {
  final String imageUrl;
  final File? file;

  const ContactAvatar({super.key, required this.imageUrl, this.file});

  String get _fullUrl {
    if (imageUrl.isEmpty) return '';
    final origin = ApiConstants.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    if (imageUrl.startsWith('http')) {
      return imageUrl.replaceFirst(RegExp(r'^https?://[^/]+'), origin);
    }
    if (imageUrl.startsWith('/')) return '$origin$imageUrl';
    return 'storage/$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;
    final hasUrl = _fullUrl.isNotEmpty;

    return CircleAvatar(
      radius: 28,
      backgroundImage: hasFile
          ? FileImage(file!)
          : (hasUrl ? NetworkImage(_fullUrl) : null),
      backgroundColor: Colors.grey[200],
      child: !hasFile && !hasUrl
          ? const Icon(Icons.person, color: Colors.grey)
          : null,
    );
  }
}
