// class EventsModel {
//   final String id;
//   final String title;
//   final String body;
//   final String image;
//   final String event_date;
//   final String registration_deadline;

//   EventsModel({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.image,
//     required this.event_date,
//     required this.registration_deadline,
//   });

//   factory EventsModel.fromJson(Map<String, dynamic> json) {
//     return EventsModel(
//       id: json["id"].toString(),
//       title: json["title"] ?? "",
//       body: json["body"] ?? "",
//       image: json["image"] ?? "",
//       event_date: json["event_date"] ?? "",
//       registration_deadline: json["registration_deadline"] ?? "",
//     );
//   }
// }
import 'dart:io';

import 'package:schooly/core/constants/api_constants.dart';

class EventsModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final String eventDate;
  final String registrationDeadline;
  final int capacity;
  final String status;
  final File? imageFile;

  EventsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.eventDate,
    required this.registrationDeadline,
    required this.capacity,
    required this.status,
    this.imageFile,
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["body"] ?? "",
      imageUrl: json["image"]?.toString() ?? "",
      location: json["location"] ?? "",
      eventDate: json["event_date"] ?? "",
      registrationDeadline: json["registration_deadline"] ?? "",
      capacity: json["capacity"] ?? 0,
      status: json["status"] ?? "",
    );
  }

  // لربط الـ File الذي ننزّله بالريبو
  EventsModel copyWith({File? imageFile}) {
    return EventsModel(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      location: location,
      eventDate: eventDate,
      registrationDeadline: registrationDeadline,
      capacity: capacity,
      status: status,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  // بناء رابط كامل من الصورة الخام (نفس resolvePhotoUrl عندك)
  static String resolveImageUrl(String raw) {
    if (raw.isEmpty) return '';
    final origin = ApiConstants.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    if (raw.startsWith('http')) {
      return raw.replaceFirst(RegExp(r'^https?://[^/]+'), origin);
    }
    if (raw.startsWith('/')) return '$origin$raw';
    return '$origin/storage/$raw';
  }
}
