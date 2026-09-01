import 'package:equatable/equatable.dart';

class LatestMessage extends Equatable {
  final int? id;
  final int? conversationId;
  final int? senderId;
  final String? message;
  final dynamic readAt;
  final String? createdAt;
  final String? updatedAt;

  const LatestMessage({
    this.id,
    this.conversationId,
    this.senderId,
    this.message,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory LatestMessage.fromJson(Map<String, dynamic> json) => LatestMessage(
    id: json['id'] as int?,
    conversationId: json['conversation_id'] as int?,
    senderId: json['sender_id'] as int?,
    message: json['message'] as String?,
    readAt: json['read_at'] as dynamic,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversation_id': conversationId,
    'sender_id': senderId,
    'message': message,
    'read_at': readAt,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  @override
  List<Object?> get props {
    return [
      id,
      conversationId,
      senderId,
      message,
      readAt,
      createdAt,
      updatedAt,
    ];
  }
}
