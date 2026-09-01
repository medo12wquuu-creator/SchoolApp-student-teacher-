class MessageModel {
  final int id;
  final int conversationId;
  final int senderId;
  final String text;
  final String time;
  final bool isMine;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.time,
    required this.isMine,
    required this.isRead,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, int currentUserId) {
    final created = DateTime.parse(json["created_at"]);

    return MessageModel(
      id: json["id"],
      conversationId: json["conversation_id"],
      senderId: json["sender_id"],
      text: json["message"],
      createdAt: created,
      time:
          "${created.hour.toString().padLeft(2, '0')}:${created.minute.toString().padLeft(2, '0')}",

      // الباك لا يرجّع is_read، يرجّع read_at
      isRead: json["read_at"] != null,

      // هل الرسالة مني؟
      isMine: json["sender_id"] == currentUserId,
    );
  }
}
