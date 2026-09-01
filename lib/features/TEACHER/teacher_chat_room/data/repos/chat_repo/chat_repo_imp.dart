import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/section_conversation_model/section_conversation_model.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/data/models/message_model.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/data/repos/chat_repo/chat_repo.dart';

class ChatRepoImp implements ChatRepo {
  final ApiService _api;
  ChatRepoImp(this._api);

  @override
  Future<Either<Failure, List<SectionConversationModel>>>
  getConversations() async {
    try {
      final response = await _api.get(endPoint: '/chat/contactsBySection');
      // 🔍 تسجيل مؤقت للتشخيص
      print(
        '🔍 [ChatRepo] getConversations response TYPE=${response.runtimeType}',
      );
      print('🔍 [ChatRepo] getConversations response BODY=$response');
      final List<dynamic> rawList;
      if (response is List) {
        rawList = response;
      } else if (response is Map && response['conversations'] is List) {
        rawList = response['conversations'] as List<dynamic>;
      } else if (response is Map && response['data'] is List) {
        rawList = response['data'] as List<dynamic>;
      } else {
        return left(ServerFailure('استجابة غير متوقعة'));
      }
      final conversations = rawList
          .map(
            (e) => SectionConversationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return right(conversations);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getMessages({
    required int conversationId,
    required int myId,
  }) async {
    try {
      final response = await _api.get(
        endPoint: '/chat/conversations/$conversationId/messages',
      );
      final List<dynamic> rawList;
      if (response is List) {
        rawList = response;
      } else if (response is Map && response['messages'] is List) {
        rawList = response['messages'] as List<dynamic>;
      } else if (response is Map && response['data'] is List) {
        rawList = response['data'] as List<dynamic>;
      } else {
        return left(ServerFailure('استجابة غير متوقعة'));
      }
      final messages = rawList
          .map((e) => MessageModel.fromJson(e as Map<String, dynamic>, myId))
          .toList();
      return right(messages);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> sendFirstMessage({
    required int receiverId,
    required String text,
    required int myId,
  }) async {
    try {
      final response = await _api.post(
        endPoint: '/chat/send',
        body: {'receiver_id': receiverId, 'message': text},
      );
      return right(MessageModel.fromJson(response, myId));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> sendMessage({
    required int conversationId,
    required String text,
    required int myId,
  }) async {
    try {
      final response = await _api.post(
        endPoint: '/chat/send',
        body: {'conversation_id': conversationId, 'message': text},
      );
      return right(MessageModel.fromJson(response, myId));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsRead({
    required int conversationId,
  }) async {
    try {
      await _api.post(
        endPoint: '/chat/conversations/$conversationId/read',
        body: const {},
      );
      return right(true);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
