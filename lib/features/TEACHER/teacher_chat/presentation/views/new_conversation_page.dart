import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/widgets/app_error_view.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/contact_model.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/section_conversation_model/section_conversation_model.dart';
import 'package:schooly/features/TEACHER/teacher_chat/presentation/view_models/contacts/contacts_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_chat/presentation/view_models/contacts/contacts_state.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/presentation/view_models/chat/chat_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/presentation/views/chat_page.dart';

class NewConversationPage extends StatefulWidget {
  final List<SectionConversationModel> sections;

  const NewConversationPage({super.key, required this.sections});

  @override
  State<NewConversationPage> createState() => _NewConversationPageState();
}

class _NewConversationPageState extends State<NewConversationPage> {
  int? _selectedSectionId;

  @override
  void initState() {
    super.initState();
    _selectedSectionId = widget.sections.firstOrNull?.sectionId;
    if (_selectedSectionId != null) {
      getIt<ContactsCubit>().loadContacts(_selectedSectionId!);
    }
  }

  void _selectSection(int? sectionId) {
    if (sectionId == null || sectionId == _selectedSectionId) return;
    setState(() => _selectedSectionId = sectionId);
    getIt<ContactsCubit>().loadContacts(sectionId);
  }

  void _openChat(ContactModel contact) {
    // 💡 الحل الجوهري: استخدام pushReplacement لعدم العودة لهذه الشاشة عند الضغط على زر الرجوع
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<ChatCubit>(),
          child: ChatPage(
            otherUserName: contact.name,
            otherUserImage: contact.personalPhoto,
            otherUserId: contact.id,
            conversationId: contact.conversationId,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kbackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kprimeryColor,
          centerTitle: true,
          title: const Text(
            'محادثة جديدة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: widget.sections.isEmpty
              ? const Center(
                  child: Text(
                    'لا توجد شعب مضافة بعد',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'اختر الشعبة',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ktextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSectionChips(),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'قائمة الطلاب',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ktextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: BlocProvider.value(
                        value: getIt<ContactsCubit>(),
                        child: BlocBuilder<ContactsCubit, ContactsState>(
                          builder: (context, state) {
                            if (state.isLoading && state.contacts.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: kprimeryColor,
                                ),
                              );
                            }
                            if (state.errorMessage != null &&
                                state.contacts.isEmpty) {
                              return AppErrorView(
                                message: state.errorMessage!,
                                onRetry: () {
                                  if (_selectedSectionId != null) {
                                    getIt<ContactsCubit>().loadContacts(
                                      _selectedSectionId!,
                                    );
                                  }
                                },
                              );
                            }
                            if (state.contacts.isEmpty) {
                              return const Center(
                                child: Text(
                                  'لا يوجد طلاب في هذه الشعبة',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }

                            return ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              itemCount: state.contacts.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final contact = state.contacts[index];
                                return _ContactTile(
                                  contact: contact,
                                  onTap: () => _openChat(contact),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSectionChips() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.sections.length,
        itemBuilder: (context, index) {
          final section = widget.sections[index];
          final isSelected = section.sectionId == _selectedSectionId;

          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () => _selectSection(section.sectionId),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [kprimeryColor, kDarkPrimaryColor],
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? kprimeryColor : klightPrimeryColor,
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: kprimeryColor.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  section.sectionName ?? 'شعبة',
                  style: TextStyle(
                    color: isSelected ? Colors.white : ktextColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
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
}

class _ContactTile extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTap;

  const _ContactTile({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasConversation = contact.conversationId != null;

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
                      radius: 25,
                      backgroundColor: klightPrimeryColor,
                      foregroundImage: contact.personalPhoto.isEmpty
                          ? null
                          : NetworkImage(contact.personalPhoto),
                      onForegroundImageError: contact.personalPhoto.isEmpty
                          ? null
                          : (_, _) {},
                      child: contact.personalPhoto.isEmpty
                          ? Text(
                              contact.name.isEmpty ? '؟' : contact.name[0],
                              style: const TextStyle(
                                color: kDarkPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: ktextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            hasConversation
                                ? Icons.chat_bubble_outline_rounded
                                : Icons.add_comment_outlined,
                            size: 13,
                            color: hasConversation
                                ? kadditionalColor
                                : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hasConversation
                                ? 'محادثة قائمة'
                                : 'بدء محادثة جديدة',
                            style: TextStyle(
                              fontSize: 12,
                              color: hasConversation
                                  ? kadditionalColor
                                  : Colors.grey[600],
                              fontWeight: hasConversation
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: klightPrimeryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: kDarkPrimaryColor,
                    size: 14,
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
