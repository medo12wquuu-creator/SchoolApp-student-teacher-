import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/presentation/view_models/chat/chat_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/presentation/view_models/chat/chat_state.dart';

import 'widgets/chat_app_bar.dart';
import 'widgets/messages_list.dart';
import 'widgets/message_input.dart';

class ChatPage extends StatefulWidget {
  final String otherUserName;
  final String otherUserImage;
  final int? conversationId;
  final int otherUserId;

  const ChatPage({
    super.key,
    required this.otherUserName,
    required this.otherUserImage,
    required this.otherUserId,
    this.conversationId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<ChatCubit>();

    if (widget.conversationId != null) {
      cubit.loadMessages(widget.conversationId!);
    } else {
      cubit.startConversation(widget.otherUserId);
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        _scrollToBottom();
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAF9FE),

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: ChatAppBar(
              name: widget.otherUserName,
              imageUrl: widget.otherUserImage,
              isOnline: true, // لاحقاً من الباك
            ),
          ),

          body: Column(
            children: [
              Expanded(
                child: state.isLoading && state.messages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : MessagesList(
                        messages: state.messages,
                        controller: scrollController,
                      ),
              ),

              if (state.isSending)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),

              MessageInput(
                controller: messageController,
                focusNode: focusNode,

                onSend: () {
                  final text = messageController.text.trim();
                  if (text.isEmpty) return;

                  if (state.conversationId == null) {
                    context.read<ChatCubit>().sendFirstMessage(
                      widget.otherUserId,
                      text,
                    );
                  } else {
                    context.read<ChatCubit>().sendMessage(text);
                  }

                  messageController.clear();
                  _scrollToBottom();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
