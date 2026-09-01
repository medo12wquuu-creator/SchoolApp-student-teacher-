import '../../data/models/outchat_model.dart';

abstract class OutChatState {
  bool get isLoading => false;
  String? get errorMessage => null;
  List<OutChatModel> get conversations => const [];
}

class OutChatInitial extends OutChatState {}

class OutChatLoading extends OutChatState {
  @override
  bool get isLoading => true;
}

class OutChatLoaded extends OutChatState {
  @override
  final List<OutChatModel> conversations;

  OutChatLoaded(this.conversations);
}

class OutChatError extends OutChatState {
  final String message;

  OutChatError(this.message);

  @override
  String? get errorMessage => message;
}
