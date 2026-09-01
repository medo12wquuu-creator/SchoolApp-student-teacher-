import 'package:equatable/equatable.dart';

import 'latest_message.dart';
import 'other_user.dart';

class Conversation extends Equatable {
  final int? id;
  final int? senderId;
  final int? receiverId;
  final String? lastMessageAt;
  final String? createdAt;
  final String? updatedAt;
  final int? unreadCount;
  final OtherUser? otherUser;
  final LatestMessage? latestMessage;

  const Conversation({
    this.id,
    this.senderId,
    this.receiverId,
    this.lastMessageAt,
    this.createdAt,
    this.updatedAt,
    this.unreadCount,
    this.otherUser,
    this.latestMessage,
  });

  Conversation copyWith({int? unreadCount, LatestMessage? latestMessage}) {
    return Conversation(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      lastMessageAt: lastMessageAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
      otherUser: otherUser,
      latestMessage: latestMessage ?? this.latestMessage,
    );
  }

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    id: json['id'] as int?,
    senderId: json['sender_id'] as int?,
    receiverId: json['receiver_id'] as int?,
    lastMessageAt: json['last_message_at'] as String?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    unreadCount: json['unread_count'] as int?,
    otherUser: json['other_user'] == null
        ? null
        : OtherUser.fromJson(json['other_user'] as Map<String, dynamic>),
    latestMessage: json['latest_message'] == null
        ? null
        : LatestMessage.fromJson(
            json['latest_message'] as Map<String, dynamic>,
          ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender_id': senderId,
    'receiver_id': receiverId,
    'last_message_at': lastMessageAt,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'unread_count': unreadCount,
    'other_user': otherUser?.toJson(),
    'latest_message': latestMessage?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      senderId,
      receiverId,
      lastMessageAt,
      createdAt,
      updatedAt,
      unreadCount,
      otherUser,
      latestMessage,
    ];
  }
}
