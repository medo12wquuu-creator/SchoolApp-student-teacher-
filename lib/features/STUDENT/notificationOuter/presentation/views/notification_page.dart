import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/AllTasks/presentation/views/tasks_screen.dart';
import 'package:schooly/features/STUDENT/Announcements/presentation/views/announcements_screen.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/presentation/views/notes_teacher_page.dart';
import 'package:schooly/features/STUDENT/QuizOut/presentation/views/quiz_out_screen.dart';
import 'package:schooly/features/STUDENT/notificationOuter/data/model/notification_model.dart';
import 'package:schooly/features/STUDENT/notificationOuter/presentation/view_models/notification_cubit.dart';
import 'package:schooly/features/STUDENT/notificationOuter/presentation/view_models/notification_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  void _handleNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) {
    final screen = (notification.payload['screen'] ?? '')
        .toString()
        .toLowerCase();

    switch (screen) {
      case 'exams':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuizOutScreen()),
        );
        break;
      case 'tasks':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TasksScreen()),
        );
        break;
      case 'announcements':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
        );
        break;
      case 'notes':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TeacherNotesScreen()),
        );
        break;
      case 'events':
      case 'login':
      case 'home':
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = context.read<NotificationCubit>();
      await cubit.initialize();
      await cubit.markAllRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1C1E) : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'الإشعارات',
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFF1F3FC),
            width: 1,
          ),
        ),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator(color: primary));
          }

          if (state.errorMessage != null && state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<NotificationCubit>().initialize(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد إشعارات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.grey.shade500
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: primary,
            onRefresh: () => context.read<NotificationCubit>().refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _NotificationCard(
                  notification: notification,
                  onTap: () => _handleNotificationTap(context, notification),
                  onDelete: () => context
                      .read<NotificationCubit>()
                      .deleteNotification(notification.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getColor(notification.type);
    final icon = _getIcon(notification.type);
    final dateText = notification.createdAt != null
        ? '${notification.createdAt!.day}/${notification.createdAt!.month}/${notification.createdAt!.year}'
        : 'الآن';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFF1F3FC),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: onDelete,
                            icon: Icon(
                              Icons.close,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                            tooltip: 'حذف الإشعار',
                            splashRadius: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'النوع: ${notification.type}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 13,
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateText,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
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

  Color _getColor(String type) {
    switch (type) {
      case 'exam.result_ready':
        return const Color(0xFF1E88E5);
      case 'note':
        return const Color(0xFF43A047);
      case 'grade':
        return const Color(0xFFF59E0B);
      case 'attendance':
        return const Color(0xFFFF7043);
      case 'schedule':
        return const Color(0xFF8E24AA);
      case 'announcement':
        return const Color(0xFFE53935);
      case 'tasks':
        return const Color(0xFF00BFA5);
      case 'events':
        return const Color(0xFF7E57C2);
      default:
        return const Color(0xFF1565C0);
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'exam.result_ready':
        return Icons.quiz_outlined;
      case 'note':
        return Icons.note_alt_outlined;
      case 'grade':
        return Icons.grade_outlined;
      case 'attendance':
        return Icons.fact_check_outlined;
      case 'schedule':
        return Icons.schedule_outlined;
      case 'announcement':
        return Icons.campaign_outlined;
      default:
        return Icons.notifications_none;
    }
  }
}
