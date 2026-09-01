import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/services/firebase_notification_service.dart';

import '../view_models/chat_cubit.dart';
import '../view_models/chat_state.dart';

import 'widgets/chat_app_bar.dart';
import 'widgets/messages_list.dart';
import 'widgets/message_input.dart';
import 'widgets/emoji_picker_widget.dart';

class ChatPage extends StatefulWidget {
  final String otherUserName;
  final String otherUserImage;
  final File? otherUserImageFile;
  final int? conversationId;
  final int otherUserId;

  const ChatPage({
    super.key,
    required this.otherUserName,
    required this.otherUserImage,
    required this.otherUserId,
    this.otherUserImageFile,
    this.conversationId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  bool showEmoji = false;

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
    FirebaseNotificationService.instance.currentOpenConversationId = null;
    messageController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // void _scrollToBottom() {
  //   if (!scrollController.hasClients) return;

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     scrollController.animateTo(
  //       scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 250),
  //       curve: Curves.easeOut,
  //     );
  //   });
  // }
  void _scrollToBottom() {
    if (!scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return; // <-- أضف هذا السطر
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
        // ✅ حدّثي المحادثة المفتوحة حالياً كل مرة يتغير فيها الـ state
        if (state.conversationId != null) {
          FirebaseNotificationService.instance.currentOpenConversationId = state
              .conversationId
              .toString();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAF9FE),

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: ChatAppBar(
              name: widget.otherUserName,
              imageUrl: widget.otherUserImage,
              imageFile: widget.otherUserImageFile,
              isOnline: true, // لاحقاً من الباك
            ),
          ),

          body: Stack(
            children: [
              // خلفية الصورة
              Positioned.fill(
                child: Image.asset(
                  'images/chatbackground.png',
                  fit: BoxFit.cover,
                ),
              ),

              // المحتوى فوق الخلفية
              Column(
                children: [
                  Expanded(
                    child: MessagesList(
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
                    showEmoji: showEmoji,

                    onEmojiPressed: () {
                      if (showEmoji) {
                        focusNode.requestFocus();
                      } else {
                        focusNode.unfocus();
                      }

                      setState(() {
                        showEmoji = !showEmoji;
                      });
                    },

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

                  EmojiPickerWidget(
                    controller: messageController,
                    visible: showEmoji,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
