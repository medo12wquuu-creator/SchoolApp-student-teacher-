import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/services/reverb_service.dart';
import 'package:schooly/features/STUDENT/Chat/data/repositories/chat_repository.dart';
import '../../data/models/message_model.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repo;
  final ReverbService reverb;
  final int myId;
  final String token;

  ChatCubit({
    required this.repo,
    required this.reverb,
    required this.myId,
    required this.token,
  }) : super(ChatState());

  /// بدء المحادثة: يحمل قائمة المحادثات ويجد المحادثة مع هذا المستخدم
  Future<void> startConversation(int otherUserId) async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true));

    try {
      final convs = await repo.loadConversations(token);
      if (isClosed) return;

      final match = convs.cast<Map<String, dynamic>>().firstWhere(
        (c) => c['receiver_id'] == otherUserId || c['sender_id'] == otherUserId,
        orElse: () => <String, dynamic>{},
      );

      if (match.isNotEmpty && match['id'] != null) {
        await loadMessages(match['id'] as int);
      } else {
        if (!isClosed) emit(state.copyWith(isLoading: false));
      }
    } catch (_) {
      if (!isClosed) emit(state.copyWith(isLoading: false));
    }
  }

  /// تحميل الرسائل عند فتح المحادثة
  Future<void> loadMessages(int conversationId) async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true));

    final data = await repo.loadMessages(conversationId, token);
    if (isClosed) return;

    final messages = data
        .map<MessageModel>((json) => MessageModel.fromJson(json, myId))
        .toList();

    if (!isClosed) {
      emit(
        state.copyWith(
          conversationId: conversationId,
          messages: messages,
          isLoading: false,
        ),
      );
    }

    _listenToConversation(conversationId);
    _markAsRead(conversationId);
  }

  /// إرسال أول رسالة (لا يوجد conversation_id بعد)
  Future<void> sendFirstMessage(int receiverId, String text) async {
    if (isClosed) return;
    emit(state.copyWith(isSending: true));

    final response = await repo.sendFirstMessage(receiverId, text, token);
    if (isClosed) return;

    final message = MessageModel.fromJson(response, myId);

    if (!isClosed) {
      emit(
        state.copyWith(
          conversationId: message.conversationId,
          messages: [...state.messages, message],
          isSending: false,
        ),
      );
    }

    _listenToConversation(message.conversationId);
    _markAsRead(message.conversationId);
  }

  /// إرسال رسالة داخل محادثة موجودة
  Future<void> sendMessage(String text) async {
    if (state.conversationId == null || isClosed) return;

    emit(state.copyWith(isSending: true));

    final response = await repo.sendMessage(state.conversationId!, text, token);
    if (isClosed) return;

    final message = MessageModel.fromJson(response, myId);

    if (!isClosed) {
      emit(
        state.copyWith(
          messages: [...state.messages, message],
          isSending: false,
        ),
      );
    }
  }

  /// تعليم الرسائل كمقروءة
  Future<void> _markAsRead(int conversationId) async {
    try {
      final result = await repo.markAsRead(conversationId, token);
      final readIds =
          (result['read_message_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [];

      if (readIds.isEmpty || isClosed) return;

      final updated = state.messages.map((m) {
        if (readIds.contains(m.id)) {
          return MessageModel(
            id: m.id,
            conversationId: m.conversationId,
            senderId: m.senderId,
            text: m.text,
            time: m.time,
            isMine: m.isMine,
            isRead: true,
            createdAt: m.createdAt,
          );
        }
        return m;
      }).toList();

      emit(state.copyWith(messages: updated));
    } catch (_) {}
  }

  /// استقبال الرسائل الجديدة عبر WebSocket
  void _listenToConversation(int conversationId) {
    reverb.listenToConversation(
      conversationId,
      (data) {
        if (isClosed) return;

        final message = MessageModel.fromJson(data, myId);
        if (message.senderId == myId) return;
        final updated = [...state.messages, message];

        emit(state.copyWith(messages: updated));

        _markAsRead(conversationId);
      },
      onRead: (data) {
        if (isClosed) return;

        final readIds =
            (data['message_ids'] as List<dynamic>?)
                ?.map((e) => int.parse(e.toString()))
                .toList() ??
            [];

        if (readIds.isEmpty) return;

        final readerId = data['reader_id'] as int?;
        if (readerId == myId) return;

        final updated = state.messages.map((m) {
          if (readIds.contains(m.id)) {
            return MessageModel(
              id: m.id,
              conversationId: m.conversationId,
              senderId: m.senderId,
              text: m.text,
              time: m.time,
              isMine: m.isMine,
              isRead: true,
              createdAt: m.createdAt,
            );
          }
          return m;
        }).toList();

        emit(state.copyWith(messages: updated));
      },
    );
  }
}
