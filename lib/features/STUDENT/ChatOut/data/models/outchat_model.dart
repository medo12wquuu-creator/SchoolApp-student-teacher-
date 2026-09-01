// import 'dart:io';

// import 'package:schooly/core/constants/api_constants.dart';

// class OutChatModel {
//   final int id;
//   final int unreadCount;
//   final int otherUserId;
//   final String otherUserName;
//   final String otherUserImage;
//   final String lastMessage;
//   final String lastMessageTime;
//   final File? personalPhotoFile;

//   OutChatModel({
//     required this.id,
//     required this.unreadCount,
//     required this.otherUserId,
//     required this.otherUserName,
//     required this.otherUserImage,
//     required this.lastMessage,
//     required this.lastMessageTime,
//     this.personalPhotoFile,
//   });

//   factory OutChatModel.fromJson(Map<String, dynamic> json) {
//     final otherUser = (json['other_user'] as Map<String, dynamic>?) ?? {};
//     final person = (otherUser['person'] as Map<String, dynamic>?) ?? {};
//     final latestMessage =
//         (json['latest_message'] as Map<String, dynamic>?) ?? {};

//     final firstName = person['first_name'] as String? ?? '';
//     final lastName = person['last_name'] as String? ?? '';

//     final timeRaw =
//         (latestMessage['created_at'] as String?) ??
//         (json['last_message_at'] as String?) ??
//         '';

//     return OutChatModel(
//       id: json['id'] as int? ?? 0,
//       unreadCount: json['unread_count'] as int? ?? 0,
//       otherUserId: otherUser['id'] as int? ?? 0,
//       otherUserName: '$firstName $lastName'.trim(),
//       otherUserImage: person['personal_photo'] as String? ?? '',
//       lastMessage: latestMessage['message'] as String? ?? '',
//       lastMessageTime: _formatTime(timeRaw),
//     );
//   }

//   OutChatModel copyWith({File? personalPhotoFile}) {
//     return OutChatModel(
//       id: id,
//       unreadCount: unreadCount,
//       otherUserId: otherUserId,
//       otherUserName: otherUserName,
//       otherUserImage: otherUserImage,
//       lastMessage: lastMessage,
//       lastMessageTime: lastMessageTime,
//       personalPhotoFile: personalPhotoFile ?? this.personalPhotoFile,
//     );
//   }

//   static String formatFromIso(String iso) {
//     if (iso.isEmpty) return '';
//     try {
//       final dt = DateTime.parse(iso).toLocal();
//       return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
//     } catch (_) {
//       return '';
//     }
//   }

//   String get otherUserImageUrl => resolvePhotoUrl(otherUserImage);

//   static String resolvePhotoUrl(String raw) {
//     if (raw.isEmpty) return '';
//     final origin = ApiConstants.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
//     if (raw.startsWith('http')) {
//       return raw.replaceFirst(RegExp(r'^https?://[^/]+'), origin);
//     }
//     if (raw.startsWith('/')) return '$origin$raw';
//     return '$origin/storage/$raw';
//   }

//   static String _formatTime(String raw) {
//     if (raw.isEmpty) return '';
//     // "2026-07-31 12:14:29" -> "12:14"
//     if (raw.length >= 16) return raw.substring(11, 16);
//     return raw;
//   }
// }
import 'dart:io';

import 'package:schooly/core/constants/api_constants.dart';

class OutChatModel {
  final int id;
  final int unreadCount;
  final int otherUserId;
  final String otherUserName;
  final String otherUserImage;
  final String lastMessage;
  final String lastMessageTime;
  final File? personalPhotoFile;

  OutChatModel({
    required this.id,
    required this.unreadCount,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.personalPhotoFile,
  });

  factory OutChatModel.fromJson(Map<String, dynamic> json) {
    final otherUser = (json['other_user'] as Map<String, dynamic>?) ?? {};
    final person = (otherUser['person'] as Map<String, dynamic>?) ?? {};
    final latestMessage =
        (json['latest_message'] as Map<String, dynamic>?) ?? {};

    final firstName = person['first_name'] as String? ?? '';
    final lastName = person['last_name'] as String? ?? '';

    final timeRaw =
        (latestMessage['created_at'] as String?) ??
        (json['last_message_at'] as String?) ??
        '';

    return OutChatModel(
      id: json['id'] as int? ?? 0,
      unreadCount: json['unread_count'] as int? ?? 0,
      otherUserId: otherUser['id'] as int? ?? 0,
      otherUserName: '$firstName $lastName'.trim(),
      otherUserImage: person['personal_photo'] as String? ?? '',
      lastMessage: latestMessage['message'] as String? ?? '',
      lastMessageTime: _formatTime(timeRaw),
    );
  }

  // ✅ الآن يدعم تحديث lastMessage و lastMessageTime و unreadCount
  OutChatModel copyWith({
    File? personalPhotoFile,
    String? lastMessage,
    String? lastMessageTime,
    int? unreadCount,
  }) {
    return OutChatModel(
      id: id,
      unreadCount: unreadCount ?? this.unreadCount,
      otherUserId: otherUserId,
      otherUserName: otherUserName,
      otherUserImage: otherUserImage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      personalPhotoFile: personalPhotoFile ?? this.personalPhotoFile,
    );
  }

  static String formatFromIso(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return '';
    }
  }

  String get otherUserImageUrl => resolvePhotoUrl(otherUserImage);

  static String resolvePhotoUrl(String raw) {
    if (raw.isEmpty) return '';
    final origin = ApiConstants.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    if (raw.startsWith('http')) {
      return raw.replaceFirst(RegExp(r'^https?://[^/]+'), origin);
    }
    if (raw.startsWith('/')) return '$origin$raw';
    return 'storage/$raw';
  }

  static String _formatTime(String raw) {
    if (raw.isEmpty) return '';
    // "2026-07-31 12:14:29" -> "12:14"
    if (raw.length >= 16) return raw.substring(11, 16);
    return raw;
  }
}
