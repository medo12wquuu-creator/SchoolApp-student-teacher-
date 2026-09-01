import 'package:dartz/dartz.dart';
  import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/section_conversation_model/section_conversation_model.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/data/models/message_model.dart';

abstract class ChatRepo {
  /// جلب كل محادثات الأستاذ مع الطلاب
  Future<Either<Failure, List<SectionConversationModel>>> getConversations();

  /// جلب الرسائل داخل محادثة موجودة
  Future<Either<Failure, List<MessageModel>>> getMessages({
    required int conversationId,
    required int myId,
  });

  /// إرسال أول رسالة (لا يوجد conversation_id بعد)
  Future<Either<Failure, MessageModel>> sendFirstMessage({
    required int receiverId,
    required String text,
    required int myId,
  });

  /// إرسال رسالة داخل محادثة موجودة
  Future<Either<Failure, MessageModel>> sendMessage({
    required int conversationId,
    required String text,
    required int myId,
  });

  /// تعليم الرسائل كمقروءة
  Future<Either<Failure, bool>> markAsRead({required int conversationId});
}
