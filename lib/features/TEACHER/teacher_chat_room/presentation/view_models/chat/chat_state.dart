 import 'package:schooly/features/TEACHER/teacher_chat_room/data/models/message_model.dart';

class ChatState {
  final int? conversationId;
  final List<MessageModel> messages;
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;

  ChatState({
    this.conversationId,
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.errorMessage,
  });

  ChatState copyWith({
    int? conversationId,
    List<MessageModel>? messages,
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
  }) {
    return ChatState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage,
    );
  }
}
