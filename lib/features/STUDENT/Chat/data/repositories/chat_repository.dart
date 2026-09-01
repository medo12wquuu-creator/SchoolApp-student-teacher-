// import 'package:schooly/features/STUDENT/Chat/data/datasource/chat_remote_data_source.dart';

// class ChatRepository {
//   final ChatRemoteDataSource remote;

//   ChatRepository(this.remote);

//   Future<List<dynamic>> loadMessages(
//     int teacherId,
//     String token,
//   ) {
//     return remote.loadMessages(
//       teacherId,
//       token,
//     );
//   }

//   Future<void> sendMessage(
//     int teacherId,
//     String message,
//     String token,
//   ) {
//     return remote.sendMessage(
//       teacherId,
//       message,
//       token,
//     );
//   }
// }
import 'package:schooly/features/STUDENT/Chat/data/datasource/chat_remote_data_source.dart';

class ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepository(this.remote);

  /// جلب كل المحادثات
  Future<List<dynamic>> loadConversations(String token) {
    return remote.loadConversations(token);
  }

  /// جلب الرسائل داخل محادثة موجودة
  Future<List<dynamic>> loadMessages(int conversationId, String token) {
    return remote.loadMessages(conversationId, token);
  }

  /// إرسال أول رسالة (لا يوجد conversation_id بعد)
  Future<Map<String, dynamic>> sendFirstMessage(
    int receiverId,
    String text,
    String token,
  ) {
    final body = {"receiver_id": receiverId, "message": text};

    return remote.sendMessage(body, token);
  }

  /// إرسال رسالة داخل محادثة موجودة
  Future<Map<String, dynamic>> sendMessage(
    int conversationId,
    String text,
    String token,
  ) {
    final body = {"conversation_id": conversationId, "message": text};

    return remote.sendMessage(body, token);
  }

  /// وضع علامة قراءة
  Future<Map<String, dynamic>> markAsRead(int conversationId, String token) {
    return remote.markAsRead(conversationId, token);
  }
}
