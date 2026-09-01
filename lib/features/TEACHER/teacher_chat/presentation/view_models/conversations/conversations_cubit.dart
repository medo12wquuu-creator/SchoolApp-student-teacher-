import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/services/chat_socket_service.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/section_conversation_model/conversation.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/section_conversation_model/latest_message.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/section_conversation_model/section_conversation_model.dart';
import 'package:schooly/features/TEACHER/teacher_chat/presentation/view_models/conversations/conversations_state.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/data/repos/chat_repo/chat_repo.dart';
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';
 
class ConversationsCubit extends Cubit<ConversationsState> {
  final ChatRepo repository;
  final ChatSocketService socket;
  final int myId;

  ConversationsCubit({
    required this.repository,
    required this.socket,
    required this.myId,
  }) : super(ConversationsInitial());

  List<SectionConversationModel> _sections = [];

  int get _currentMyId => getIt<UserCubitt>().currentUser?.id ?? myId;

  Future<void> loadConversations() async {
    emit(ConversationsLoading());

    try {
      // 1. جلب البيانات من الـ API أولاً وبشكل مستقل
      final result = await repository.getConversations();
      if (isClosed) return;

      result.fold(
        (failure) {
          // 🔍 تسجيل مؤقت للتشخيص
          log('❌ فشل جلب الشعب/المحادثات: ${failure.errMassage}');
          if (!isClosed) emit(ConversationsError(failure.errMassage));
        },
        (sections) {
          // 🔍 تسجيل مؤقت للتشخيص
          log('✅ تم جلب ${sections.length} شعب (sections)');
          _sections = sections;

          // إرسال البيانات للواجهة فوراً لكي تظهر للشاشات وتتفكك حالة التعليق
          if (!isClosed) emit(ConversationsLoaded(List.of(_sections)));

          // 2. محاولة الاتصال بالسوكت داخل try-catch منعزلة تماماً
          _safeStartSocketListeners();
        },
      );
    } catch (e) {
      log('❌ استثناء أثناء جلب المحادثات: $e');
      if (!isClosed) {
        emit(ConversationsError('حدث خطأ أثناء تحميل المحادثات: $e'));
      }
    }
  }

  void _safeStartSocketListeners() {
    try {
      _listenToAll();
    } catch (e) {
      // طباعة الخطأ فقط دون تأثر حالة الكيوبيت أو تعليق الـ UI
      print("⚠️ تعذر تشغيل مستمعات السوكت: $e");
    }
  }

  void _listenToAll() {
    if (!socket.isConnected) return;

    for (final section in _sections) {
      final convs = section.conversations ?? const <Conversation>[];
      for (final conv in convs) {
        final conversationId = conv.id;
        if (conversationId == null) continue;

        socket.listenToConversation(conversationId, (data) {
          if (isClosed) return;

          final senderId = data['sender_id'] as int?;
          final message = data['message'] as String? ?? '';
          final createdAt = data['created_at'] as String? ?? '';

          _applyIncomingMessage(
            conversationId,
            senderId: senderId,
            message: message,
            createdAt: createdAt,
          );
        });
      }
    }
  }

  void _applyIncomingMessage(
    int conversationId, {
    int? senderId,
    required String message,
    required String createdAt,
  }) {
    bool updatedAny = false;

    final updatedSections = _sections.map((section) {
      final convs = section.conversations ?? const <Conversation>[];
      final convIndex = convs.indexWhere((c) => c.id == conversationId);
      if (convIndex == -1) return section;

      updatedAny = true;
      final oldConv = convs[convIndex];
      final isMine = senderId == _currentMyId;
      final updatedConv = oldConv.copyWith(
        unreadCount: isMine
            ? oldConv.unreadCount
            : (oldConv.unreadCount ?? 0) + 1,
        latestMessage: LatestMessage(
          id: oldConv.latestMessage?.id,
          conversationId: conversationId,
          senderId: senderId ?? _currentMyId,
          message: message,
          readAt: oldConv.latestMessage?.readAt,
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
      );

      final updatedConvs = List<Conversation>.from(convs);
      updatedConvs[convIndex] = updatedConv;

      return SectionConversationModel(
        sectionId: section.sectionId,
        sectionName: section.sectionName,
        conversations: updatedConvs,
      );
    }).toList();

    if (updatedAny) {
      _sections = updatedSections;
      if (!isClosed) emit(ConversationsLoaded(List.of(_sections)));
    }
  }

  void markConversationAsOpened(int conversationId) {
    final updatedSections = _sections.map((section) {
      final convs = section.conversations ?? const <Conversation>[];
      final convIndex = convs.indexWhere((c) => c.id == conversationId);
      if (convIndex == -1) return section;

      final updatedConv = convs[convIndex].copyWith(unreadCount: 0);
      final updatedConvs = List<Conversation>.from(convs);
      updatedConvs[convIndex] = updatedConv;

      return SectionConversationModel(
        sectionId: section.sectionId,
        sectionName: section.sectionName,
        conversations: updatedConvs,
      );
    }).toList();

    _sections = updatedSections;
    if (!isClosed) emit(ConversationsLoaded(List.of(_sections)));
  }
}
