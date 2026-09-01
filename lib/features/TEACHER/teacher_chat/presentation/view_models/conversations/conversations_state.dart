 import 'package:schooly/features/TEACHER/teacher_chat/data/models/section_conversation_model/section_conversation_model.dart';

abstract class ConversationsState {
  bool get isLoading => false;
  String? get errorMessage => null;
  List<SectionConversationModel> get conversations => const [];
}

class ConversationsInitial extends ConversationsState {}

class ConversationsLoading extends ConversationsState {
  @override
  bool get isLoading => true;
}

class ConversationsLoaded extends ConversationsState {
  @override
  final List<SectionConversationModel> conversations;

  ConversationsLoaded(this.conversations);
}

class ConversationsError extends ConversationsState {
  final String message;

  ConversationsError(this.message);

  @override
  String? get errorMessage => message;
}
