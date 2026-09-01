import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/services/chat_socket_service.dart';
import 'package:schooly/core/services/firebaseteacher.dart';
import 'package:schooly/features/TEACHER/teacher_chat/presentation/view_models/conversations/conversations_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_chat/presentation/views/techer_chat.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/teacher_classes/teacher_classes_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/classes.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/fetch_teacher_profile_info/fetch_profile_info_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/widgets/teacher_appbar.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/widgets/teacher_bottom_navigation_bar.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/widgets/teacher_home_body.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/presentation/view_models/weak_schedual/weak_schedual_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/presentation/views/teacher_weak_schedual.dart';
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';

class TeacherHome extends StatefulWidget {
  final int initialTab;
  const TeacherHome({super.key, this.initialTab = 0});
  // const TeacherHome({super.key});

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> with WidgetsBindingObserver {
  late int _currentIndex = widget.initialTab;

  // 1. تعريف الـ PageController للتحكم بالانتقال
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const TeacherHomeBody(),
    const Classes(),
    const TeacherChat(),
    const TeacherWeakSchedual(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final userToken = getIt<UserCubitt>().token;
    if (userToken != null && userToken.isNotEmpty) {
      getIt<ChatSocketService>().connect(token: userToken);
    }
    FirebaseNotificationService.instance.refreshUnreadCount();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseNotificationService.instance.refreshUnreadCount();
    }
  }

  // أضف هذه الدالة داخل _TeacherHomeState
  void _refreshCurrentTab(int index) {
    switch (index) {
      case 0:
        getIt<FetchProfileInfoCubit>().fetchProfileInfo();
        break;
      case 1:
        context.read<TeacherClassesCubit>().fetchTeacherClasses();
        break;
      case 2:
        getIt<ConversationsCubit>().loadConversations();
        break;
      case 3:
        getIt<WeakSchedualCubit>().fetchSchedual();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<FetchProfileInfoCubit>(),
      child: Scaffold(
        backgroundColor: kbackgroundColor,
        appBar: const TeacherAppBar(),
        // استخدام IndexedStack يحافظ على "حالة" كل صفحة (السكروول ما بيرجع للبدابة)
        body: IndexedStack(
          index: _currentIndex,
          children: _pages.map((page) {
            // إضافة انيميشن بسيط لكل صفحة تظهر
            return AnimatedOpacity(
              opacity: _pages.indexOf(page) == _currentIndex ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: page,
            );
          }).toList(),
        ),
        bottomNavigationBar: TeacherBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _refreshCurrentTab(index);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose(); // تنظيف الذاكرة
    super.dispose();
  }
}
