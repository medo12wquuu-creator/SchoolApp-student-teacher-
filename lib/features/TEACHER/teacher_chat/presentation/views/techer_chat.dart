import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/widgets/app_error_view.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/section_conversation_model/conversation.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/section_conversation_model/section_conversation_model.dart';
import 'package:schooly/features/TEACHER/teacher_chat/presentation/view_models/conversations/conversations_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_chat/presentation/view_models/conversations/conversations_state.dart';
import 'package:schooly/features/TEACHER/teacher_chat/presentation/views/new_conversation_page.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/presentation/view_models/chat/chat_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/presentation/views/chat_page.dart';

class TeacherChat extends StatefulWidget {
  const TeacherChat({super.key});

  @override
  State<TeacherChat> createState() => _TeacherChatState();
}

class _TeacherChatState extends State<TeacherChat> {
  int? _selectedSectionId;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getIt<ConversationsCubit>().loadConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // تصفية المحادثات حسب الشعبة والبحث
  List<Conversation> _visibleConversations(
    List<SectionConversationModel> sections,
  ) {
    List<Conversation> filtered = [];

    if (_selectedSectionId == null) {
      filtered = sections
          .expand((s) => s.conversations ?? const <Conversation>[])
          .toList();
    } else {
      final selectedSection = sections.firstWhere(
        (s) => s.sectionId == _selectedSectionId,
        orElse: () => const SectionConversationModel(),
      );
      filtered = selectedSection.conversations ?? [];
    }

    if (_searchQuery.trim().isEmpty) return filtered;

    final query = _searchQuery.trim().toLowerCase();
    return filtered
        .where(
          (c) =>
              (_conversationName(c).toLowerCase().contains(query)) ||
              (_lastMessage(c).toLowerCase().contains(query)),
        )
        .toList();
  }

  String _conversationName(Conversation c) {
    final person = c.otherUser?.person;
    final firstName = person?.firstName ?? '';
    final lastName = person?.lastName ?? '';
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? 'طالب' : name;
  }

  String _lastMessage(Conversation c) => c.latestMessage?.message ?? '';

  String _time(Conversation c) {
    final raw = c.latestMessage?.createdAt ?? c.lastMessageAt ?? '';
    if (raw.isEmpty) return '';
    if (raw.length >= 16) return raw.substring(11, 16);
    return raw;
  }

  bool _isOnline(Conversation c) => c.otherUser?.status == 'online';
  String _avatarUrl(Conversation c) => c.otherUser?.person?.personalPhoto ?? '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kbackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final sections = getIt<ConversationsCubit>().state.conversations;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewConversationPage(sections: sections),
              ),
            ).then((_) => getIt<ConversationsCubit>().loadConversations());
          },
          backgroundColor: kprimeryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          icon: const Icon(Icons.edit, color: Colors.white, size: 20),
          label: const Text(
            'محادثة جديدة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocProvider.value(
            value: getIt<ConversationsCubit>(),
            child: BlocBuilder<ConversationsCubit, ConversationsState>(
              builder: (context, state) {
                if (state.isLoading && state.conversations.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: kprimeryColor),
                  );
                }
                if (state.errorMessage != null && state.conversations.isEmpty) {
                  return AppErrorView(
                    message: state.errorMessage!,
                    onRetry: () =>
                        getIt<ConversationsCubit>().loadConversations(),
                  );
                }

                final currentConversations = _visibleConversations(
                  state.conversations,
                );

                // اسم الشعبة المحددة حالياً لعرضها إذا كانت القائمة فارغة
                String currentSectionName = 'هذه الشعبة';
                if (_selectedSectionId != null) {
                  final found = state.conversations.firstWhere(
                    (s) => s.sectionId == _selectedSectionId,
                    orElse: () => const SectionConversationModel(),
                  );
                  if (found.sectionName != null) {
                    currentSectionName = 'شعبة ${found.sectionName}';
                  }
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await getIt<ConversationsCubit>().loadConversations();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 8),

                      // شريط البحث
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: klightPrimeryColor,
                              width: 1.4,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                            decoration: const InputDecoration(
                              hintText: 'بحث في الرسائل أو أسماء الطلاب...',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: kprimeryColor,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 1️⃣ إظهار جميع الشعب القادمة من الباك إند
                      _buildFilterChips(state.conversations),

                      const SizedBox(height: 12),

                      // 2️⃣ عرض المحادثات أو واجهة البدء عند الفراغ
                      Expanded(
                        child: state.conversations.isEmpty
                            ? _buildEmptyState(
                                'ليس لديك شعب مضافة بعد',
                                state.conversations,
                              )
                            : currentConversations.isEmpty
                            ? _buildEmptyState(
                                _selectedSectionId == null
                                    ? 'لا توجد محادثات سابقة'
                                    : 'لا توجد محادثات سابقة في $currentSectionName',
                                state.conversations,
                              )
                            : _buildConversationList(
                                state.conversations,
                                currentConversations,
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // 🆕 الهيدر بتدرج أزرق مميز
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kprimeryColor, kDarkPrimaryColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kprimeryColor.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الرسائل والمحادثات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: kwhiteColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'تواصل مع طلابك بسهولة وسرعة',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.forum_rounded,
              color: kwhiteColor,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  // أزرار الفلترة للشعب
  Widget _buildFilterChips(List<SectionConversationModel> sections) {
    if (sections.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: sections.length + 1,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final isSelected = isAll
              ? _selectedSectionId == null
              : sections[index - 1].sectionId == _selectedSectionId;

          final label = isAll
              ? 'الكل'
              : sections[index - 1].sectionName ??
                    'شعبة ${sections[index - 1].sectionId ?? ""}';

          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSectionId = isAll
                      ? null
                      : sections[index - 1].sectionId;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [kprimeryColor, kDarkPrimaryColor],
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? kprimeryColor : klightPrimeryColor,
                    width: 1.2,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : ktextColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
    String message,
    List<SectionConversationModel> sections,
  ) {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(), // لتفعيل السحب للتحديث حتى أثناء الفراغ
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: klightPrimeryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 44,
                  color: kprimeryColor,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ktextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConversationList(
    List<SectionConversationModel> allSections,
    List<Conversation> conversations,
  ) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: conversations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final conv = conversations[index];
        final sectionName = allSections
            .firstWhere(
              (s) => (s.conversations ?? []).any((c) => c.id == conv.id),
              orElse: () => const SectionConversationModel(),
            )
            .sectionName;

        return _ChatItemCard(
          name: _conversationName(conv),
          message: _lastMessage(conv),
          time: _time(conv),
          tag: sectionName ?? '',
          unreadCount: conv.unreadCount ?? 0,
          isOnline: _isOnline(conv),
          avatarUrl: _avatarUrl(conv),
          onTap: () {
            if (conv.id != null) {
              getIt<ConversationsCubit>().markConversationAsOpened(conv.id!);
            }
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) =>
            //     BlocProvider(
            //       create: (_) => getIt<ChatCubit>(),
            //       child: ChatPage(
            //         otherUserName: _conversationName(conv),
            //         otherUserImage: _avatarUrl(conv),
            //         otherUserId: conv.otherUser?.id ?? 0,
            //         conversationId: conv.id,
            //       ),
            //     ),
            //   ),
            // ).then((_) => getIt<ConversationsCubit>().loadConversations());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (routeContext) => BlocProvider(
                  create: (routeContext) => getIt<ChatCubit>(),
                  child: ChatPage(
                    otherUserName: _conversationName(conv),
                    otherUserImage: _avatarUrl(conv),
                    otherUserId: conv.otherUser?.id ?? 0,
                    conversationId: conv.id,
                  ),
                ),
              ),
            ).then((_) => getIt<ConversationsCubit>().loadConversations());
          },
        );
      },
    );
  }
}

class _ChatItemCard extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String tag;
  final int unreadCount;
  final bool isOnline;
  final String avatarUrl;
  final VoidCallback onTap;

  const _ChatItemCard({
    required this.name,
    required this.message,
    required this.time,
    required this.tag,
    required this.unreadCount,
    required this.isOnline,
    required this.avatarUrl,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: klightPrimeryColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: kprimeryColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: klightPrimeryColor,
                      foregroundImage: avatarUrl.isEmpty
                          ? null
                          : NetworkImage(avatarUrl),
                      onForegroundImageError: avatarUrl.isEmpty
                          ? null
                          : (_, _) {},
                      child: avatarUrl.isEmpty
                          ? Text(
                              name.isEmpty ? '؟' : name[0],
                              style: const TextStyle(
                                color: kDarkPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: kadditionalColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: ktextColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            time,
                            style: TextStyle(
                              color: unreadCount > 0
                                  ? kprimeryColor
                                  : Colors.grey,
                              fontSize: 11,
                              fontWeight: unreadCount > 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message.isEmpty ? 'انقر لبدء المحادثة' : message,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: unreadCount > 0
                                    ? ktextColor
                                    : Colors.grey[600],
                                fontSize: 13,
                                fontWeight: unreadCount > 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: kRedColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (tag.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: klightPrimeryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: kDarkPrimaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
