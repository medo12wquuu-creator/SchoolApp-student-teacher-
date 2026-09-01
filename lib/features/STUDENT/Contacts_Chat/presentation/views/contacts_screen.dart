// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
// import 'package:schooly/core/constants/api_constants.dart';
// import 'package:schooly/core/constants/loading.dart';
// import 'package:schooly/core/errors/failed_to_load_widget.dart';
// import 'package:schooly/core/services/reverb_service.dart';
// import 'package:schooly/features/STUDENT/Chat/data/datasource/chat_remote_data_source.dart';
// import 'package:schooly/features/STUDENT/Chat/data/repositories/chat_repository.dart';
// import 'package:schooly/features/STUDENT/Chat/presentation/view_models/chat_cubit.dart';
// import 'package:schooly/features/STUDENT/Chat/presentation/views/chat_page.dart';
// import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
// import '../../data/datasource/contact_remote_data_source.dart';
// import '../../data/models/contact_model.dart';
// import '../../data/repositories/contact_repository.dart';
// import '../view_models/contact_cubit.dart';
// import '../view_models/contact_state.dart';
// import 'widgets/contact_tile.dart';

// class ContactsScreen extends StatelessWidget {
//   const ContactsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ContactCubit(
//         ContactRepository(ContactRemoteDataSource(Dio())),
//         context.read<UserCubit>(),
//       )..loadContacts(),
//       child: const _ContactsBody(),
//     );
//   }
// }

// class _ContactsBody extends StatelessWidget {
//   const _ContactsBody();

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final primary = Colors.purple;
//     final background = isDark
//         ? const Color(0xFF121212)
//         : const Color(0xFFF8F9FF);

//     return Scaffold(
//       backgroundColor: background,
//       appBar: AppBar(
//         backgroundColor: isDark ? const Color(0xFF1A1C1E) : Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new, color: primary),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'معلميني',
//           style: TextStyle(color: primary, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search, color: primary),
//             onPressed: () {},
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Container(
//             color: isDark
//                 ? Colors.white.withValues(alpha: 0.08)
//                 : Colors.grey.withValues(alpha: 0.1),
//             height: 1.0,
//           ),
//         ),
//       ),
//       body: BlocBuilder<ContactCubit, ContactState>(
//         builder: (context, state) {
//           if (state.isLoading) {
//             return Center(
//               child: Lottie.asset(loading.couple, width: 120, height: 120),
//             );
//           }

//           // if (state.errorMessage != null) {
//           //   return Center(child: Text(state.errorMessage!));
//           // }
//           if (state.errorMessage != null) {
//             return FailedToLoadWidget(
//               itemName: 'جهات التواصل مع المعلمين❌',
//               onRetry: () => context.read<ContactCubit>().loadContacts(),
//             );
//           }
//           if (state.contacts.isEmpty) {
//             return const Center(
//               child: Text(
//                 'لا يوجد أساتذة يمكنك التواصل معهم الآن',
//                 textAlign: TextAlign.center,
//               ),
//             );
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             itemCount: state.contacts.length,
//             separatorBuilder: (_, _) => Divider(
//               indent: 80,
//               endIndent: 20,
//               color: Theme.of(context).dividerColor,
//               height: 1,
//             ),
//             itemBuilder: (_, index) => ContactTile(
//               contact: state.contacts[index],
//               onTap: () => _openChat(context, state.contacts[index]),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _openChat(BuildContext context, ContactModel contact) {
//     final userCubit = context.read<UserCubit>();
//     final token = userCubit.token ?? '';
//     final myId = userCubit.currentUser?.id ?? 0;

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => BlocProvider(
//           create: (_) => ChatCubit(
//             repo: ChatRepository(ChatRemoteDataSource(Dio())),
//             reverb: ReverbService(
//               appKey: "suph6ug028gzlw8wdwib",
//               wssHost: ApiConstants.wss,
//               httpHost: "https://diving-settle-careless.ngrok-free.dev",
//               token: token,
//             ),
//             myId: myId,
//             token: token,
//           ),
//           child: ChatPage(
//             otherUserName: contact.name,
//             otherUserImage: contact.photoUrl,
//             otherUserImageFile: contact.personalPhotoFile,
//             otherUserId: contact.id,
//             conversationId: contact.conversationId,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/constants/loading.dart';
import 'package:schooly/core/errors/failed_to_load_widget.dart';
import 'package:schooly/core/services/reverb_service.dart';
import 'package:schooly/features/STUDENT/Chat/data/datasource/chat_remote_data_source.dart';
import 'package:schooly/features/STUDENT/Chat/data/repositories/chat_repository.dart';
import 'package:schooly/features/STUDENT/Chat/presentation/view_models/chat_cubit.dart';
import 'package:schooly/features/STUDENT/Chat/presentation/views/chat_page.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import '../../data/datasource/contact_remote_data_source.dart';
import '../../data/models/contact_model.dart';
import '../../data/repositories/contact_repository.dart';
import '../view_models/contact_cubit.dart';
import '../view_models/contact_state.dart';
import 'widgets/contact_tile.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactCubit(
        ContactRepository(ContactRemoteDataSource(Dio())),
        context.read<UserCubit>(),
      )..loadContacts(),
      child: const _ContactsBody(),
    );
  }
}

class _ContactsBody extends StatefulWidget {
  const _ContactsBody();

  @override
  State<_ContactsBody> createState() => _ContactsBodyState();
}

class _ContactsBodyState extends State<_ContactsBody> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  List<ContactModel> _filterContacts(List<ContactModel> contacts) {
    if (_searchQuery.isEmpty) return contacts;
    return contacts
        .where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Colors.purple;
    final background = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FF);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1C1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF4F3F8)),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF4F3F8)),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF4F3F8)),
                  ),

                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFF4F3F8)),
                  ),

                  fillColor: Color.fromARGB(161, 2, 0, 4),

                  hintText: 'ابحث عن معلم...',
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 158, 158, 158),
                    fontSize: 16,
                  ),
                ),
              )
            : Text(
                'معلميني',
                style: TextStyle(color: primary, fontWeight: FontWeight.bold),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: primary,
            ),
            onPressed: _toggleSearch,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.grey.withValues(alpha: 0.1),
            height: 1.0,
          ),
        ),
      ),
      body: BlocBuilder<ContactCubit, ContactState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Lottie.asset(loading.couple, width: 120, height: 120),
            );
          }

          if (state.errorMessage != null) {
            return FailedToLoadWidget(
              itemName: 'جهات التواصل مع المعلمين❌',
              onRetry: () => context.read<ContactCubit>().loadContacts(),
            );
          }

          final filtered = _filterContacts(state.contacts);

          if (filtered.isEmpty) {
            return Center(
              child: Text(
                _searchQuery.isNotEmpty
                    ? 'لا يوجد نتائج لـ "$_searchQuery"'
                    : 'لا يوجد أساتذة يمكنك التواصل معهم الآن',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => Divider(
              indent: 80,
              endIndent: 20,
              color: Theme.of(context).dividerColor,
              height: 1,
            ),
            itemBuilder: (_, index) => ContactTile(
              contact: filtered[index],
              onTap: () => _openChat(context, filtered[index]),
            ),
          );
        },
      ),
    );
  }

  void _openChat(BuildContext context, ContactModel contact) {
    final userCubit = context.read<UserCubit>();
    final token = userCubit.token ?? '';
    final myId = userCubit.currentUser?.id ?? 0;

    Navigator.push(
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
            otherUserName: contact.name,
            otherUserImage: contact.photoUrl,
            otherUserImageFile: contact.personalPhotoFile,
            otherUserId: contact.id,
            conversationId: contact.conversationId,
          ),
        ),
      ),
    );
  }
}
