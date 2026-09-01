import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/ChatOut/presentation/views/outchatslistscreen.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/homePageStudent.dart';
import 'package:schooly/features/STUDENT/schedule/presentation/views/schedule_page.dart';
import 'package:schooly/features/STUDENT/student_profile/presentation/views/student_profile.dart';
// import 'package:schooly/features/Grade/presentation/views/grade.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/buttom_navigation_bar.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class StudentMainLayout extends StatefulWidget {
  const StudentMainLayout({super.key});

  @override
  State<StudentMainLayout> createState() => StudentMainLayoutState();
}

class StudentMainLayoutState extends State<StudentMainLayout> {
  final GlobalKey _homeKey = GlobalKey(); // الصفحة الرئيسية
  final GlobalKey _scheduleKey = GlobalKey(); // برنامج الأسبوع
  final GlobalKey _chatKey = GlobalKey(); // محادثة
  final GlobalKey _profileKey = GlobalKey(); // ملف الشخصي
  final PageController _pageController = PageController();
  int currentIndex = 0;
  int _lastTourIndex = -1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _showPageTourAfterLayout(int index) async {
    if (!mounted || index == _lastTourIndex) return;
    _lastTourIndex = index;

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted || currentIndex != index) return;

    final prefs = await SharedPreferences.getInstance();
    switch (index) {
      case 1: // برنامج الأسبوع
        if (prefs.getBool('tour_schedule') ?? false) return;
        await prefs.setBool('tour_schedule', true);
        ShowcaseView.get().dismiss();
        ShowcaseView.get().startShowCase([_scheduleKey]);
        break;
      case 2: // محادثة
        if (prefs.getBool('tour_chat') ?? false) return;
        await prefs.setBool('tour_chat', true);
        ShowcaseView.get().dismiss();
        ShowcaseView.get().startShowCase([_chatKey]);
        break;
      case 3: // ملف الشخصي
        if (prefs.getBool('tour_profile') ?? false) return;
        await prefs.setBool('tour_profile', true);
        ShowcaseView.get().dismiss();
        ShowcaseView.get().startShowCase([_profileKey]);
        break;
    }
  }

  void changeTab(int index) {
    ShowcaseView.get().dismiss();
    if (index == currentIndex) return;

    setState(() => currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
    _showPageTourAfterLayout(index);
  }

  @override
  Widget build(BuildContext context) {
    // 1) استخرج الـ cubit نفسه بدل نوع الحالة
    final userCubit = context.watch<UserCubit>();

    // 2) استخرج المستخدم والـ token من الحقول المباشرة
    final user = userCubit.currentUser;
    final token = userCubit.token;

    // 3) لو المستخدم لسا ما تحمل
    if (user == null || token == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 4) قائمة الصفحات
    final List<Widget> pages = [
      Showcase(
        key: _homeKey,
        title: 'الصفحة الرئيسية',
        description: 'جدولك الدراسي لكل أيام الأسبوع',
        child: const HomeStudentPage(),
      ),
      Showcase(
        key: _scheduleKey,
        title: 'برنامج الأسبوع',
        description: 'جدولك الدراسي لكل أيام الأسبوع',
        child: const SchedulePage(),
      ),
      Showcase(
        key: _chatKey,
        title: 'محادثة',
        description: 'راسل معلميك من هنا',
        child: const OutChatsListScreen(),
      ),
      Showcase(
        key: _profileKey,
        title: 'ملف الشخصي',
        description: 'بياناتك الشخصية وملفك الكامل',
        child: const ProfilePage(),
      ),
    ];
    // 5) الـ Scaffold الأساسي
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (index == currentIndex) return;
          setState(() => currentIndex = index);
          _showPageTourAfterLayout(index);
        },
        physics: const BouncingScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: changeTab,
      ),
    );
  }
}
