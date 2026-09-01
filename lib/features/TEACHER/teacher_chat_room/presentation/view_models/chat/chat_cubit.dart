import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/services/chat_socket_service.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/section_conversation_model/conversation.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/data/models/message_model.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/data/repos/chat_repo/chat_repo.dart';
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';
 
import 'chat_state.dart';

/// نفس منطق ChatCubit في تطبيق الطالب — محادثة الأستاذ مع طالب واحد
class ChatCubit extends Cubit<ChatState> {
  final ChatRepo repo;
  final ChatSocketService socket;
  final int myId;

  ChatCubit({required this.repo, required this.socket, required this.myId})
    : super(ChatState());

  int get _currentMyId => getIt<UserCubitt>().currentUser?.id ?? myId;

  /// بدء المحادثة: يحمل قائمة المحادثات ويجد المحادثة مع هذا المستخدم
  Future<void> startConversation(int otherUserId) async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true));

    try {
      final result = await repo.getConversations();
      if (isClosed) return;

      result.fold(
        (failure) {
          if (!isClosed) {
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: failure.errMassage,
              ),
            );
          }
        },
        (sections) async {
          final matches = sections
              .expand((s) => s.conversations ?? const <Conversation>[])
              .where((c) => c.otherUser?.id == otherUserId)
              .toList();
          if (matches.isNotEmpty) {
            await loadMessages(matches.first.id ?? 0);
          } else {
            if (!isClosed) emit(state.copyWith(isLoading: false));
          }
        },
      );
    } catch (_) {
      if (!isClosed) emit(state.copyWith(isLoading: false));
    }
  }

  /// تحميل الرسائل عند فتح المحادثة
  Future<void> loadMessages(int conversationId) async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true));

    final result = await repo.getMessages(
      conversationId: conversationId,
      myId: _currentMyId,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(isLoading: false, errorMessage: failure.errMassage),
          );
        }
      },
      (messages) {
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
      },
    );
  }

  /// إرسال أول رسالة (لا يوجد conversation_id بعد)
  Future<void> sendFirstMessage(int receiverId, String text) async {
    if (isClosed) return;
    emit(state.copyWith(isSending: true));

    final result = await repo.sendFirstMessage(
      receiverId: receiverId,
      text: text,
      myId: _currentMyId,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(isSending: false, errorMessage: failure.errMassage),
          );
        }
      },
      (message) {
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
      },
    );
  }

  /// إرسال رسالة داخل محادثة موجودة
  Future<void> sendMessage(String text) async {
    if (state.conversationId == null || isClosed) return;

    emit(state.copyWith(isSending: true));

    final result = await repo.sendMessage(
      conversationId: state.conversationId!,
      text: text,
      myId: _currentMyId,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(isSending: false, errorMessage: failure.errMassage),
          );
        }
      },
      (message) {
        if (!isClosed) {
          emit(
            state.copyWith(
              messages: [...state.messages, message],
              isSending: false,
            ),
          );
        }
      },
    );
  }

  /// تعليم الرسائل كمقروءة
  Future<void> _markAsRead(int conversationId) async {
    try {
      final result = await repo.markAsRead(conversationId: conversationId);
      result.fold((_) {}, (readIds) {
        if (isClosed) return;
        final updated = state.messages.map((m) {
          if (m.isRead) return m;
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
        }).toList();
        emit(state.copyWith(messages: updated));
      });
    } catch (_) {}
  }

  /// استقبال الرسائل الجديدة عبر الاتصال اللحظي
  void _listenToConversation(int conversationId) {
    socket.listenToConversation(
      conversationId,
      (data) {
        if (isClosed) return;

        final message = MessageModel.fromJson(data, _currentMyId);
        if (message.senderId == _currentMyId) return;
        final updated = [...state.messages, message];

        emit(state.copyWith(messages: updated));

        _markAsRead(conversationId);
      },
      onRead: (data) {
        if (isClosed) return;

        // تحدّثني الباك مرة بـ message_ids ومرة بـ read_message_ids — نتعامل مع الاثنين
        final rawIds =
            (data['message_ids'] as List<dynamic>?) ??
            (data['read_message_ids'] as List<dynamic>?) ??
            const <dynamic>[];

        final readIds = rawIds
            .map((e) => int.tryParse(e.toString()))
            .whereType<int>()
            .toList();

        if (readIds.isEmpty) return;

        final readerId = data['reader_id'] as int?;
        if (readerId == _currentMyId) return;

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

  /// 🛑 عند إغلاق الشاشة نوقف الاستماع لهذه المحادثة فقط دون فصل الـ Socket
  @override
  Future<void> close() {
    if (state.conversationId != null) {
      socket.stopListeningToConversation(state.conversationId!);
    }
    return super.close();
  }
}
