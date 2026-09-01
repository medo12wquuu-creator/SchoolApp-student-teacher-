import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:schooly/core/errors/failed_to_load_widget.dart';
import 'package:schooly/core/services/firebase_notification_service.dart';
import 'package:schooly/core/theme/theme_cubit.dart';
import 'package:schooly/features/STUDENT/AllTasks/presentation/views/tasks_screen.dart';
import 'package:schooly/features/STUDENT/Announcements/presentation/views/announcements_screen.dart';
import 'package:schooly/features/STUDENT/Grade/presentation/views/grade_page.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/data/datasource/note_teacher_remote_data_source.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/data/repository/note_teatcher_repository.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/presentation/view_models/note_teatcher_cubit.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/presentation/views/notes_teacher_page.dart';
import 'package:schooly/features/STUDENT/QuizOut/presentation/views/quiz_out_screen.dart';

// Cubits
import 'package:schooly/features/STUDENT/home/presentation/view_models/home_cubit.dart';
import 'package:schooly/features/STUDENT/home/presentation/view_models/home_state.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/EVENT/events_screen.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/EVENT/horizontal_events_list.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/GHANGE_PASSWORD/edit_password.dart';
import 'package:schooly/features/STUDENT/notificationOuter/presentation/views/notification_launcher.dart';
import 'package:schooly/features/STUDENT/student_profile/data/datasource/student_profile_remote_data_source.dart';
import 'package:schooly/features/STUDENT/student_profile/data/repositories/student_profile_repository.dart';
import 'package:schooly/features/STUDENT/student_profile/presentation/view_models/cubit_profile.dart';
import 'package:schooly/features/STUDENT/student_profile/presentation/view_models/state_profile.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/views/login.dart';

// Widgets
import 'package:schooly/features/STUDENT/home/presentation/views/widget/home_header.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/ATTENDANCE_ABSENCE/attendance_absences.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/quick_links_other_pages.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/section_header.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/TASK/tasks_list.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/SCHEDULE/schedule_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeStudentPage extends StatefulWidget {
  const HomeStudentPage({super.key});

  @override
  State<HomeStudentPage> createState() => _HomeStudentPageState();
}

class _HomeStudentPageState extends State<HomeStudentPage>
    with WidgetsBindingObserver {
  final GlobalKey _attendanceKey = GlobalKey();
  final GlobalKey _gradesKey = GlobalKey();
  final GlobalKey _quizzesKey = GlobalKey();
  final GlobalKey _announcementsKey = GlobalKey();
  final GlobalKey _notesKey = GlobalKey();
  final GlobalKey _headerKey = GlobalKey(); // رئيسية
  final GlobalKey _tasksKey = GlobalKey(); // مهام الغد
  final GlobalKey _scheduleSectionKey = GlobalKey(); // برنامج الغد
  final GlobalKey _eventsSectionKey = GlobalKey(); // الأحداث القادمة
  final GlobalKey _notificationsKey = GlobalKey(); // الإشعارات
  final GlobalKey _menuKey = GlobalKey(); // القائمة
  final GlobalKey _refreshKey = GlobalKey(); // تحديث
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<HomeCubit>().loadHomeData();
    FirebaseNotificationService.instance.refreshUnreadCount();

    _maybeShowOnboarding();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseNotificationService.instance.refreshUnreadCount();
    }
  }

  Future<void> _maybeShowOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyShown = prefs.getBool('home_showcase_shown') ?? false;
    if (alreadyShown) return; // لا نعرض مرة أخرى

    await prefs.setBool('home_showcase_shown', true); // علّم أنه عُرض

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowcaseView.get().startShowCase([
        _menuKey, // 1 القائمة
        _notificationsKey, // 2 الإشعارات
        _headerKey, // 3 رئيسية
        _attendanceKey, // 4 الحضور والغياب
        _gradesKey, // 5 علامات
        _quizzesKey, // 6 اختبارات
        _announcementsKey, // 7 إعلانات مدرسية
        _notesKey, // 8 ملاحظات المعلمين
        _tasksKey, // 9 مهام الغد
        _scheduleSectionKey, // 10 برنامج الغد
        _eventsSectionKey, // 11 الأحداث القادمة
        _refreshKey, // 12 تحديث
      ]);
    });
  }

  void _onQuickLinkPressed(String label) {
    switch (label) {
      case 'علامات':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GradePage()),
        );
        break;
      case 'اختبارات':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuizOutScreen()),
        );
        break;
      // openNotificationPage(context);
      // break;
      case 'ملاحظات المعلمين':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => NoteTeacherCubit(
                NoteTeacherRepository(NoteTeacherRemoteDataSource(Dio())),
                context.read<UserCubit>(),
              )..loadNotes(),
              child: const TeacherNotesScreen(),
            ),
          ),
        );
        break;
      case 'إعلانات مدرسية':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AnnouncementsScreen()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label page is not implemented yet')),
        );

        break;
    }
  }

  void _logout(BuildContext context) async {
    final userCubit = context.read<UserCubit>();
    await userCubit.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    final user = context.watch<UserCubit>().currentUser;
    final profile = context.watch<StudentProfileCubit>().profile;
    ImageProvider? avatarProvider;
    if (profile?.personalPhoto != null) {
      avatarProvider = FileImage(profile!.personalPhoto!);
    } else if (profile?.cleanPhotoUrl != null &&
        profile!.cleanPhotoUrl!.isNotEmpty) {
      avatarProvider = NetworkImage(profile.cleanPhotoUrl!);
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final drawerBg = isDark ? const Color(0xFF1A1C1E) : Colors.white;
    final dividerColor = isDark
        ? Colors.grey.shade800
        : const Color(0xFFF1F3FC);

    return Drawer(
      backgroundColor: drawerBg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: avatarProvider,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    child: avatarProvider == null
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile?.firstLastName ??
                              user?.first_name ??
                              "", //  home_header.dart هنا احضر الاسم كما فعلت سابقا مع
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '', // هنا احضر الايميل
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _drawerSectionTitle('الإعدادات'),
            _drawerTile(
              icon: Icons.dark_mode_outlined,
              title: 'المظهر',
              onTap: () {
                context.read<ThemeCubit>().toggleTheme();
                Navigator.pop(context);
              },
            ),
            _drawerTile(icon: Icons.language, title: 'اللغة', onTap: () {}),
            // _drawerTile(
            //   icon: Icons.notifications_outlined,
            //   title: 'الإشعارات',
            //   onTap: () {},
            // ),
            _drawerTile(
              icon: Icons.lock_outline,
              title: 'تغيير كلمة المرور',
              onTap: () {
                showChangePasswordSheet(context);
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 1, color: dividerColor),
            ),

            _drawerTile(
              icon: Icons.phone_outlined,
              title: 'تواصل معنا',
              onTap: () {},
            ),
            _drawerTile(
              icon: Icons.help_outline,
              title: 'مساعدة',
              onTap: () {},
            ),
            _drawerTile(
              icon: Icons.description_outlined,
              title: 'سياسة الخصوصية',
              onTap: () {},
            ),
            _drawerTile(icon: Icons.info_outline, title: 'حول', onTap: () {}),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 1, color: dividerColor),
            ),

            _drawerTile(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              color: Colors.redAccent,
              onTap: () => _logout(context),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Schooly v1.0',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerSectionTitle(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(
        icon,
        color:
            color ?? (isDark ? Colors.grey.shade300 : const Color(0xFF44474E)),
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color ?? (isDark ? Colors.white : const Color(0xFF1A1C1E)),
        ),
      ),
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backGround = isDark
        ? "images/homebackground2.png"
        : "images/homebackground.png";
    // 🔥 قراءة بيانات المستخدم من UserCubit
    // final user = context.watch<UserCubit>().currentUser;
    return BlocProvider(
      create: (context) => StudentProfileCubit(
        StudentProfileRepository(StudentProfileRemoteDataSource(Dio())),
        context.read<UserCubit>(),
      )..loadProfile(),
      child: Scaffold(
        drawer: Builder(builder: (context) => _buildDrawer(context)),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => Showcase(
              key: _menuKey,
              title: 'القائمة',
              description: 'اضغط هنا لفتح القائمة الجانبية وإعداداتك',

              child: IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Color(0xFF1565C0),
                  size: 28,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          actions: [
            ValueListenableBuilder<int>(
              valueListenable:
                  FirebaseNotificationService.instance.unreadCountNotifier,
              builder: (context, unreadCount, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Showcase(
                      key: _notificationsKey,
                      title: 'الإشعارات',
                      description: 'تابع إشعاراتك والرسائل غير المقروءة هنا',

                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Color(0xFF1565C0),
                          size: 28,
                        ),
                        onPressed: () => openNotificationPage(context),
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        floatingActionButton: Showcase(
          key: _refreshKey,
          title: 'تحديث',
          description: 'يمكنك تحديث الصفحة يدويًا من هنا anytime',

          child: FloatingActionButton(
            onPressed: () => context.read<HomeCubit>().loadHomeData(),
            child: const Icon(Icons.refresh),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Stack(
          children: [
            Positioned.fill(child: Image.asset(backGround, fit: BoxFit.cover)),
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------------------
                    // 🔵 Header: اسم وصورة الطالب
                    // ---------------------------------------------------------
                    // ---------------------------------------------------------
                    // 🔵 Header: اسم وصورة الطالب (من البروفايل نفسه)
                    // ---------------------------------------------------------
                    Showcase(
                      key: _headerKey,
                      title: 'الرئيسية',
                      description:
                          'هذا هو اسمك هنا، وتبدأ من هذه الصفحة الرئيسية',
                      enableAutoScroll: true,

                      child:
                          BlocBuilder<StudentProfileCubit, StudentProfileState>(
                            builder: (context, state) {
                              final profile = state is StudentProfileLoaded
                                  ? state.profile
                                  : state is StudentProfileUpdated
                                  ? state.profile
                                  : context.read<StudentProfileCubit>().profile;

                              return GreetingHeader(
                                name: profile?.firstLastName ?? "student",
                                avatarFile: profile?.personalPhoto,
                                avatarUrl: profile?.cleanPhotoUrl,
                              );
                            },
                          ),
                    ),

                    const SizedBox(height: 24),

                    // ---------------------------------------------------------
                    // 🟢 Attendance Section (الحضور والغياب)
                    // ---------------------------------------------------------
                    Showcase(
                      key: _attendanceKey,
                      title: 'الحضور والغياب',
                      description:
                          'هنا تظهر نسبة حضورك وعدد ايام غيابك في الفصل',
                      enableAutoScroll: true,

                      targetPadding: const EdgeInsets.all(6),
                      targetShapeBorder: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: BlocBuilder<HomeCubit, HomeState>(
                        buildWhen: (prev, curr) =>
                            prev.attendance != curr.attendance ||
                            prev.attendanceLoading != curr.attendanceLoading ||
                            prev.attendanceError != curr.attendanceError,
                        builder: (context, state) {
                          if (state.attendance != null) {
                            return MetricsRow(
                              attendance:
                                  state.attendance!.attendance /
                                  100, // تحويل النسبة إلى قيمة بين 0 و 1
                              absences: state.attendance!.absences,
                            );
                          }

                          if (state.attendanceLoading) {
                            return SizedBox(
                              height: 140,
                              child: Center(
                                child: Lottie.asset(
                                  'assets/animation/loading (2).json',
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                              //  Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (state.attendanceError != null) {
                            return FailedToLoadWidget(
                              itemName: 'الحضور/الغياب❌',
                              onRetry: () =>
                                  context.read<HomeCubit>().getAttendance(),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ---------------------------------------------------------
                    // Quick Links
                    // ---------------------------------------------------------
                    QuickLinksRow(
                      links: [
                        QuickLinkModel(
                          icon: Icons.star_outline,
                          label: 'علامات',
                          bgColor: Color(0xFF0D47A1),
                          showcaseKey: _gradesKey,
                          showcaseDescription: 'شاهد علاماتك وفصلك الدراسي هنا',
                        ),
                        QuickLinkModel(
                          icon: Icons.quiz_outlined,
                          label: 'اختبارات',

                          bgColor: Color(0xFF1976D2),
                          showcaseKey: _quizzesKey,
                          showcaseDescription:
                              'اختبراتك القادمة والمتاحة تجدها هنا',
                        ),
                        QuickLinkModel(
                          icon: Icons.rate_review,
                          label: 'إعلانات مدرسية',
                          bgColor: Color(0xFF42A5F5),
                          showcaseKey: _announcementsKey,
                          showcaseDescription: 'أحدث إعلانات المدرسة هنا',
                        ),
                        QuickLinkModel(
                          icon: Icons.notes_outlined,
                          label: 'ملاحظات المعلمين',
                          bgColor: Color.fromARGB(255, 146, 204, 252),
                          showcaseKey: _notesKey,
                          showcaseDescription: 'ملاحظات المعلمين حول أدائك',
                        ),
                      ],
                      onLinkPressed: _onQuickLinkPressed,
                    ),

                    const SizedBox(height: 32),
                    // ---------------------------------------------------------
                    // 🟠 Tasks Section
                    // ---------------------------------------------------------
                    Showcase(
                      key: _tasksKey,
                      title: 'مهام الغد',
                      description: 'مهامك المطلوبة منك غداً',
                      enableAutoScroll: true,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "مهام الغد",
                            hasViewAll: true,
                            onViewAll: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const TasksScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          BlocBuilder<HomeCubit, HomeState>(
                            buildWhen: (prev, curr) =>
                                prev.tasks != curr.tasks ||
                                prev.tasksLoading != curr.tasksLoading ||
                                prev.tasksError != curr.tasksError,
                            builder: (context, state) {
                              if (state.tasks != null) {
                                final accentColors = [
                                  const Color(0xFF0EA5E9),
                                  const Color(0xFF22C55E),
                                  const Color(0xFFF59E0B),
                                  const Color(0xFF8B5CF6),
                                  const Color(0xFFEC4899),
                                ];

                                final uiTasks = state.tasks!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      final index = entry.key;
                                      final task = entry.value;
                                      return TaskItemModel(
                                        subjectName: task.subjectName,
                                        title: task.title,
                                        description: task.description,
                                        deliveryDate: task.deliveryDate,
                                        accent:
                                            accentColors[index %
                                                accentColors.length],
                                        icon: task.icon,
                                      );
                                    })
                                    .toList();

                                if (uiTasks.isEmpty) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.task_alt,
                                          size: 40,
                                          color: const Color.fromARGB(
                                            255,
                                            105,
                                            185,
                                            254,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'لا توجد مهام للغد',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                              255,
                                              106,
                                              106,
                                              106,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return TasksList(tasks: uiTasks);
                              }

                              if (state.tasksLoading) {
                                return SizedBox(
                                  height: 140,
                                  child: Center(
                                    child: Lottie.asset(
                                      'assets/animation/loading (2).json',
                                      width: 120,
                                      height: 120,
                                    ),
                                  ),
                                );
                              }
                              if (state.tasksError != null) {
                                return FailedToLoadWidget(
                                  itemName: "مهام الغد❌",
                                  onRetry: () =>
                                      context.read<HomeCubit>().getTasks(),
                                );
                              }

                              if (state.tasksError != null) {
                                return Text(
                                  state.tasksError!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ---------------------------------------------------------
                    // 🟣 Schedule Section
                    // ---------------------------------------------------------
                    Showcase(
                      key: _scheduleSectionKey,
                      title: 'برنامج الغد',
                      description: 'جدول حصصك ليوم غد',
                      enableAutoScroll: true,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(title: "برنامج الغد"),
                          const SizedBox(height: 16),

                          BlocBuilder<HomeCubit, HomeState>(
                            buildWhen: (prev, curr) =>
                                prev.schedule != curr.schedule ||
                                prev.scheduleLoading != curr.scheduleLoading ||
                                prev.scheduleError != curr.scheduleError,
                            builder: (context, state) {
                              if (state.schedule != null) {
                                final uiSchedule = state.schedule!.map((e) {
                                  return ScheduleModel(
                                    subjectId: e.subjectId,
                                    subjectName: e.subjectName,
                                    teacherName: e.teacherFirstName,
                                    startTime: e.startTime,
                                    accent: Colors.orange,
                                  );
                                }).toList();

                                if (uiSchedule.isEmpty) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'لم يُنشر البرنامج الأسبوعي بعد',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return ScheduleList(
                                  items: uiSchedule,
                                  onItemPressed: (subjectName) {},
                                );
                              }

                              if (state.scheduleLoading) {
                                return SizedBox(
                                  height: 140,
                                  child: Center(
                                    child: Lottie.asset(
                                      'assets/animation/loading (2).json',
                                      width: 120,
                                      height: 120,
                                    ),
                                  ),
                                );
                              }
                              if (state.scheduleError != null) {
                                return FailedToLoadWidget(
                                  itemName: "برنامج الغد❌",
                                  onRetry: () =>
                                      context.read<HomeCubit>().getSchedule(),
                                );
                              }

                              if (state.scheduleError != null) {
                                return Text(
                                  state.scheduleError!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ---------------------------------------------------------
                    // 🟣 Events Section
                    // ---------------------------------------------------------
                    Showcase(
                      key: _eventsSectionKey,
                      title: 'الاحداث القادمة',
                      description: 'أحدث الفعاليات والمسابقات القادمة',
                      enableAutoScroll: true,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "الاحداث القادمة",
                            hasViewAll: true,
                            onViewAll: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EventsScreen(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          BlocBuilder<HomeCubit, HomeState>(
                            buildWhen: (prev, curr) =>
                                prev.events != curr.events ||
                                prev.eventsLoading != curr.eventsLoading ||
                                prev.eventsError != curr.eventsError ||
                                prev.registeredEvents !=
                                    curr.registeredEvents ||
                                prev.isLoading != curr.isLoading,
                            builder: (context, state) {
                              if (state.events != null) {
                                if (state.events!.isEmpty) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.event_outlined,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'لا توجد أحداث قادمة حالياً',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return HorizontalEventsList(
                                  events: state.events!,
                                  registeredEvents: state.registeredEvents,
                                  isRegistering: state.isLoading,
                                  onRegister: (event) => context
                                      .read<HomeCubit>()
                                      .registerCompetition(event.id),
                                );
                              }

                              if (state.eventsLoading) {
                                return SizedBox(
                                  height: 120,
                                  child: Center(
                                    child: Lottie.asset(
                                      'assets/animation/loading (2).json',
                                      width: 120,
                                      height: 120,
                                    ),
                                  ),
                                );
                              }

                              if (state.eventsError != null) {
                                return FailedToLoadWidget(
                                  itemName: 'الاحداث❌',
                                  onRetry: () =>
                                      context.read<HomeCubit>().getEvents(),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ---------------------------------------------------------
                    // Success Message Listener
                    // ---------------------------------------------------------
                    BlocListener<HomeCubit, HomeState>(
                      listenWhen: (prev, curr) =>
                          prev.successMessage != curr.successMessage,
                      listener: (context, state) {
                        if (state.successMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.successMessage!)),
                          );
                        }
                      },
                      child: const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
