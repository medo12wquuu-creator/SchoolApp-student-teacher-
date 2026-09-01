import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failed_to_load_widget.dart';
import 'package:schooly/core/services/reverb_service.dart';
import 'package:schooly/features/STUDENT/Chat/data/datasource/chat_remote_data_source.dart';
import 'package:schooly/features/STUDENT/Chat/data/repositories/chat_repository.dart';
import 'package:schooly/features/STUDENT/Chat/presentation/view_models/chat_cubit.dart';
import 'package:schooly/features/STUDENT/Chat/presentation/views/chat_page.dart';
import 'package:schooly/features/STUDENT/Contacts_Chat/presentation/views/contacts_screen.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import '../../data/datasource/out_chat_remote_data_source.dart';
import '../../data/models/outchat_model.dart';
import '../../data/repositories/out_chat_repository.dart';
import '../view_models/out_chat_cubit.dart';
import '../view_models/out_chat_state.dart';
import 'widgets/outchat_tile.dart';

class OutChatPage extends StatelessWidget {
  const OutChatPage({super.key});

  @override
  Widget build(BuildContext context) => const OutChatsListScreen();
}

class OutChatsListScreen extends StatefulWidget {
  const OutChatsListScreen({super.key});

  @override
  State<OutChatsListScreen> createState() => _OutChatsListScreenState();
}

class _OutChatsListScreenState extends State<OutChatsListScreen>
    with WidgetsBindingObserver {
  late final OutChatCubit _cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final userCubit = context.read<UserCubit>();
    final token = userCubit.token ?? '';

    _cubit = OutChatCubit(
      OutChatRepository(OutChatRemoteDataSource(Dio())),
      userCubit,
      ReverbService(
        appKey: "suph6ug028gzlw8wdwib",
        wssHost: ApiConstants.wss,
        httpHost: "https://diving-settle-careless.ngrok-free.dev",
        token: token,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshConversations(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshConversations(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshConversations();
    }
  }

  void _refreshConversations() {
    if (!mounted) return;

    final token = context.read<UserCubit>().token ?? '';
    if (token.isEmpty) return;

    _cubit.loadConversations();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: _cubit, child: const _OutChatsBody());
  }
}

class _OutChatsBody extends StatelessWidget {
  const _OutChatsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المحادثات مع المعلمين',
          style: TextStyle(
            fontSize: 22,
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ContactsScreen()),
          );
          if (context.mounted) {
            context.read<OutChatCubit>().loadConversations();
          }
        },
        child: const Icon(Icons.contacts),
      ),
      body: BlocBuilder<OutChatCubit, OutChatState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Center(
                child: Lottie.asset(
                  'assets/animation/loading (3).json',
                  width: 120,
                  height: 120,
                ),
              ),
            );
          }

          // if (state.errorMessage != null) {
          //   return Center(child: Text(state.errorMessage!));
          // }
          if (state.errorMessage != null) {
            return FailedToLoadWidget(
              itemName: 'المحادثات السابقة❌',
              onRetry: () => context.read<OutChatCubit>().loadConversations(),
            );
          }

          if (state.conversations.isEmpty) {
            return const Center(child: Text('لا توجد محادثات'));
          }

          return ListView.builder(
            itemCount: state.conversations.length,
            itemBuilder: (_, i) => OutChatTile(
              conversation: state.conversations[i],
              onTap: () async {
                await _openChat(context, state.conversations[i]);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openChat(
    BuildContext context,
    OutChatModel conversation,
  ) async {
    final userCubit = context.read<UserCubit>();
    final token = userCubit.token ?? '';
    final myId = userCubit.currentUser?.id ?? 0;
    final outChatCubit = context.read<OutChatCubit>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ChatCubit(
            repo: ChatRepository(ChatRemoteDataSource(Dio())),
            reverb: ReverbService(
              appKey: "suph6ug028gzlw8wdwib",
              wssHost: ApiConstants.wss,
              httpHost: "https://diving-settle-careless.ngrok-free.dev",
              token: token,
            ),
            myId: myId,
            token: token,
          ),
          child: ChatPage(
            otherUserName: conversation.otherUserName,
            otherUserImage: conversation.otherUserImageUrl,
            otherUserImageFile: conversation.personalPhotoFile,
            otherUserId: conversation.otherUserId,
            conversationId: conversation.id,
          ),
        ),
      ),
    );

    if (context.mounted) {
      outChatCubit.markConversationAsOpened(conversation.id);
      outChatCubit.loadConversations();
    }
  }
}

// BlocProvider(
//   create: (_) => ChatCubit(
//     repo: ChatRepository(ChatRemoteDataSource(Dio())),
//     reverb: ReverbService(
//       // wssHost: "wss://reality-gently-lending-normally.trycloudflare.com",
//       wssHost:
//           "wss://simple-front-mobility-examining.trycloudflare.com",
//       httpHost: "https://diving-settle-careless.ngrok-free.dev",
//       token: token!,
//       appKey:
//           "suph6ug028gzlw8wdwib", // ← ضع هنا REVERB_APP_KEY من Laravel .env
//     ),
//     myId: user!.id, // ← من UserModel
//     token: token, // ← من UserCubit
//   ),
//   child: ChatPage(
//     otherUserName: 'Teacher',
//     otherUserImage: 'https://example.com/teacher_image.jpg',
//     otherUserId: 1,
//   ),
// ),
