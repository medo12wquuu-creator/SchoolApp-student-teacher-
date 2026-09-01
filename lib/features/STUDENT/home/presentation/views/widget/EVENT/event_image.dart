// import 'package:flutter/material.dart';

// class EventImage extends StatelessWidget {
//   final String image;

//   const EventImage({super.key, required this.image});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//       child: Image.network(
//         image,// هنا اريدك ان تاخذ الصورة التي تجلبها من الباك ك FILE وان تقوم بعرضها هنا بدل الصورة من الانترنت
//         height: 200,
//         width: double.infinity,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schooly/core/constants/api_constants.dart';

class EventImage extends StatelessWidget {
  final File? file;
  final String imageUrl;

  const EventImage({super.key, this.file, this.imageUrl = ''});

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    if (file != null) {
      provider = FileImage(file!);
    } else {
      final url = _fullUrl;
      if (url.isNotEmpty) provider = NetworkImage(url);
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: provider == null
          ? _placeholder()
          : Image(
              image: provider,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(),
            ),
    );
  }

  String get _fullUrl {
    if (imageUrl.isEmpty) return '';
    final origin = ApiConstants.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    if (imageUrl.startsWith('http')) {
      return imageUrl.replaceFirst(RegExp(r'^https?://[^/]+'), origin);
    }
    if (imageUrl.startsWith('/')) return '$origin$imageUrl';
    return '$origin/storage/$imageUrl';
  }

  Widget _placeholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: const Color(0xFFE2E8F0),
      child: const Icon(Icons.event, size: 60, color: Color(0xFF94A3B8)),
    );
  }
}
