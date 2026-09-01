import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic> payload;
  final DateTime? readAt;
  final DateTime? createdAt;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  NotificationModel({
    this.id = '',
    required this.title,
    required this.body,
    required this.type,
    Map<String, dynamic>? payload,
    this.readAt,
    this.createdAt,
    Map<String, dynamic>? data,
    DateTime? timestamp,
  }) : payload = payload ?? const {},
       data = data ?? const {},
       timestamp = timestamp ?? DateTime.now();

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      id: (message.data['id'] ?? '').toString(),
      title: message.notification?.title ?? message.data['title'] ?? '',
      body: message.notification?.body ?? message.data['body'] ?? '',
      type: message.data['type'] ?? 'general',
      payload: Map<String, dynamic>.from(message.data),
      data: Map<String, dynamic>.from(message.data),
      timestamp: DateTime.now(),
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['created_at'] ?? json['createdAt'];
    final readAtValue = json['read_at'] ?? json['readAt'];
    final payload = Map<String, dynamic>.from(
      json['payload'] as Map? ?? const {},
    );

    final created = createdAtValue != null
        ? DateTime.tryParse(createdAtValue.toString()) ?? DateTime.now()
        : DateTime.now();

    return NotificationModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      type: (json['type'] ?? 'general').toString(),
      payload: payload,
      readAt: readAtValue != null
          ? DateTime.tryParse(readAtValue.toString())
          : null,
      createdAt: created,
      data: payload,
      timestamp: created,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'payload': payload,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String() ?? timestamp.toIso8601String(),
    };
  }

  String encode() => jsonEncode(toJson());
}
