
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/widgets/app_snack_bar.dart';
import 'package:schooly/core/widgets/custom_error_widget.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/fetch_homework_and_task_model/fetch_homework_and_task_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_deails_fetch_homework/fetch_homework_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_delete_task_homework/delete_task_homework_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_fetch_tasks/fetch_task_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/class_details_action_card.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/class_details_add_class_report.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/class_details_add_dialog.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/class_details_alert_card.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/class_details_assignment_card.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/class_details_exam_item.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/class_details_section_header.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/classes_details_students_card.dart';

// ... (نفس الـ Imports والمُدخلات)

class ClassesDetailsBody extends StatefulWidget {
  final String sectionId;
  final String semesterId;
  final String? semesterName;
  final String sectionName;

  const ClassesDetailsBody({
    super.key,
    required this.sectionId,
    required this.semesterId,
    this.semesterName,
    required this.sectionName,
  });

  @override
  State<ClassesDetailsBody> createState() => _ClassesDetailsBodyState();
}

class _ClassesDetailsBodyState extends State<ClassesDetailsBody> {
  String get _sectionId => widget.sectionId;

  @override
  void initState() {
    super.initState();
    context.read<FetchHomeworkCubit>().fetchHomework(_sectionId);
    context.read<FetchTaskCubit>().fetchTasks(_sectionId);
  }

  void _confirmDeleteActivity(FetchHomeworkAndTaskModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xffFCE8E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: kRedColor,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'حذف العنصر',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ktextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'هل أنت متأكد من رغبتك في حذف هذا العنصر؟ لا يمكن التراجع عن هذا الإجراء.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kRedColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          final id = item.id;
                          if (id != null) {
                            context
                                .read<DeleteTaskHomeworkCubit>()
                                .deleteTaskHomework(id);
                          }
                        },
                        child: const Text(
                          'تأكيد الحذف',
                          style: TextStyle(
                            color: kwhiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                            color: ktextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteTaskHomeworkCubit, DeleteTaskHomeworkState>(
      listener: (context, state) {
        if (state is DeleteTaskHomeworkSuccess) {
          showAppSuccessSnackBar(context, 'تم حذف العنصر بنجاح');
          context.read<FetchTaskCubit>().fetchTasks(_sectionId);
          context.read<FetchHomeworkCubit>().fetchHomework(_sectionId);
        } else if (state is DeleteTaskHomeworkFailure) {
          showAppErrorSnackBar(context, state.errMassage, title: 'تعذر الحذف');
        }
      },
      child: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kbackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                ClassesDetailsStudentsCard(
                  sectionId: _sectionId,
                  semesterId: widget.semesterId,
                  semesterName: widget.semesterName,
                  sectionName: widget.sectionName,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final saved = await showDialog<bool>(
                            context: context,
                            builder: (context) => ClassDetailsAddDialog(
                              type: HomeworkOrExam.exam,
                              sectionId: _sectionId,
                            ),
                          );
                          // 🆕 بعد الحفظ يتم تحديث القائمة فوراً
                          if (saved == true) {
                            context
                                .read<FetchTaskCubit>()
                                .fetchTasks(_sectionId);
                            context
                                .read<FetchHomeworkCubit>()
                                .fetchHomework(_sectionId);
                          }
                        },
                        child: ClassDetailsActionCard(
                          title: 'إضافة اختبار',
                          icon: Icons.add_circle_outline,
                          color: klightAdditionalColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final saved = await showDialog<bool>(
                            context: context,
                            builder: (context) => ClassDetailsAddDialog(
                              type: HomeworkOrExam.homework,
                              sectionId: _sectionId,
                            ),
                          );
                          // 🆕 بعد الحفظ يتم تحديث القائمة فوراً
                          if (saved == true) {
                            context
                                .read<FetchHomeworkCubit>()
                                .fetchHomework(_sectionId);
                            context
                                .read<FetchTaskCubit>()
                                .fetchTasks(_sectionId);
                          }
                        },
                        child: ClassDetailsActionCard(
                          title: 'إضافة واجب',
                          icon: Icons.assignment_turned_in_outlined,
                          color: klightSecoderyColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const ClassDetailsSectionHeader(
                  title: 'الاختبارات القادمة',
                  actionText: 'الكل',
                ),
                const SizedBox(height: 12),
                BlocBuilder<FetchTaskCubit, FetchTaskState>(
                  builder: (context, state) {
                    if (state is FetchTaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is FetchTaskFailure) {
                      return CustomErrorWidget(
                        title: 'فشل تحميل الاختبارات',
                        errorMessage: state.errMassage,
                        onRetry: () => context
                            .read<FetchTaskCubit>()
                            .fetchTasks(_sectionId),
                      );
                    }
                    if (state is FetchTaskSucces) {
                      final items = state.fetchTask;
                      if (items.isEmpty) {
                        return _buildEmptyState(
                          Icons.calculate_outlined,
                          'لا توجد اختبارات قادمة',
                          kprimeryColor,
                        );
                      }
                      return Column(
                        children: items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ClassDetailsExamItem(
                              title: item.description ?? '---',
                              date: item.deliveryDate ?? '---',
                              icon: Icons.calculate_outlined,
                              iconColor: kprimeryColor,
                              onDelete: () => _confirmDeleteActivity(item),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return _buildEmptyState(
                      Icons.calculate_outlined,
                      'لا توجد اختبارات قادمة',
                      kprimeryColor,
                    );
                  },
                ),
                const SizedBox(height: 24),
                const ClassDetailsSectionHeader(
                  title: 'الواجبات الحالية',
                  actionText: 'متابعة',
                ),
                const SizedBox(height: 12),
                BlocBuilder<FetchHomeworkCubit, FetchHomeworkState>(
                  builder: (context, state) {
                    if (state is FetchHomeworkLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is FetchHomeworkFailure) {
                      return CustomErrorWidget(
                        title: 'فشل تحميل الواجبات',
                        errorMessage: state.errMassage,
                        onRetry: () => context
                            .read<FetchHomeworkCubit>()
                            .fetchHomework(_sectionId),
                      );
                    }
                    if (state is FetchHomeworkSucces) {
                      final items = state.fetchHomework;
                      if (items.isEmpty) {
                        return _buildEmptyState(
                          Icons.assignment_turned_in_outlined,
                          'لا توجد واجبات حالية',
                          kseconderyColor,
                        );
                      }
                      return Column(
                        children: items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ClassDetailsAssignmentCard(
                              title: item.description ?? '---',
                              subject: item.subject?.name ?? '',
                              date: item.deliveryDate ?? '---',
                              onDelete: () => _confirmDeleteActivity(item),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return _buildEmptyState(
                      Icons.assignment_turned_in_outlined,
                      'لا توجد واجبات حالية',
                      kseconderyColor,
                    );
                  },
                ),
                const SizedBox(height: 24),

                const ClassDetailsSectionHeader(
                  title: 'تقارير الشعبة',
                  actionText: '',
                ),
                const SizedBox(height: 12),

                // Card التقارير الكلي مع زر الإضافة
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kwhiteColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: ktextColor.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: ktextColor.withOpacity(0.06)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kLightRedColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.assignment_late_rounded,
                          color: kRedColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'إجمالي التقارير',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: ktextColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // الزر المعدل: ناعم وغير صارخ بصرياً
                      TextButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ClassDetailsAddClassReport(
                              sectionId: widget.sectionId,
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: kLightRedColor.withOpacity(0.12),
                          foregroundColor: kRedColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: kRedColor.withOpacity(0.2)),
                          ),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text(
                          'إضافة تقرير',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                ClassDetailsAlertCard(
                  sectionName: widget.sectionName,
                  sectionId: widget.sectionId,
                  semesterId: widget.semesterId,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  // حالة فارغة أنيقة بنفس طابع التطبيق
  Widget _buildEmptyState(IconData icon, String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color.withOpacity(0.7), size: 30),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyle(
              color: ktextColor.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
