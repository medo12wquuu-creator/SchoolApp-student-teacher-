// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:schooly/features/user/presentation/view_models/user_cubit.dart';
// import '../../data/repositories/out_chat_repository.dart';
// import 'out_chat_state.dart';

// class OutChatCubit extends Cubit<OutChatState> {
//   final OutChatRepository repository;
//   final UserCubit userCubit;

//   OutChatCubit(this.repository, this.userCubit) : super(OutChatInitial());

//   Future<void> loadConversations() async {
//     emit(OutChatLoading());

//     try {
//       final token = userCubit.token ?? '';
//       final convs = await repository.getConversations(token);
//       emit(OutChatLoaded(convs));
//     } catch (e) {
//       emit(OutChatError(e.toString()));
//     }
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/services/reverb_service.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import '../../data/models/outchat_model.dart';
import '../../data/repositories/out_chat_repository.dart';
import 'out_chat_state.dart';

class OutChatCubit extends Cubit<OutChatState> {
  final OutChatRepository repository;
  final UserCubit userCubit;
  final ReverbService reverb;

  OutChatCubit(this.repository, this.userCubit, this.reverb)
    : super(OutChatInitial());

  List<OutChatModel> _conversations = [];

  Future<void> loadConversations() async {
    emit(OutChatLoading());

    try {
      final token = userCubit.token ?? '';
      final convs = await repository.getConversations(token);
      _conversations = convs;

      if (!isClosed) emit(OutChatLoaded(List.of(_conversations)));

      _listenToAll(); // ✅ استماع دائم لكل محادثة بالقائمة
    } catch (e) {
      if (!isClosed) emit(OutChatError(e.toString()));
    }
  }

  void _listenToAll() {
    final myId = userCubit.currentUser?.id ?? 0;

    for (final conv in _conversations) {
      reverb.listenToConversation(conv.id, (data) {
        if (isClosed) return;

        final senderId = data['sender_id'] as int?;
        final message = data['message'] as String? ?? '';
        final createdAt = data['created_at'] as String? ?? '';

        _applyIncomingMessage(
          conv.id,
          message: message,
          time: OutChatModel.formatFromIso(createdAt),
          isMine: senderId == myId,
        );
      });
    }
  }

  void _applyIncomingMessage(
    int conversationId, {
    required String message,
    required String time,
    required bool isMine,
  }) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;

    final old = _conversations[index];
    final updated = old.copyWith(
      lastMessage: message,
      lastMessageTime: time,
      // ما نزيد العداد إذا الرسالة مبعوتة مني أنا
      unreadCount: isMine ? old.unreadCount : old.unreadCount + 1,
    );

    _conversations = List.of(_conversations)..[index] = updated;

    if (!isClosed) emit(OutChatLoaded(List.of(_conversations)));
  }

  /// يُستدعى عند الرجوع من صفحة الشات — لتصفير العداد محلياً فوراً
  void markConversationAsOpened(int conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;

    final updated = _conversations[index].copyWith(unreadCount: 0);
    _conversations = List.of(_conversations)..[index] = updated;

    if (!isClosed) emit(OutChatLoaded(List.of(_conversations)));
  }

  @override
  Future<void> close() {
    reverb.disconnect();
    return super.close();
  }
}
