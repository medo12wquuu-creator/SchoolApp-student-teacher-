
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/class_students.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_fetch_Attendance/fetch_atendance_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_take_Attendance/cubit/take_atendance_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/class_details_students_attendance.dart';

class ClassesDetailsStudentsCard extends StatelessWidget {
  final String sectionId;
  final String semesterId;
  final String? semesterName;
  final String sectionName;

  const ClassesDetailsStudentsCard({
    super.key,
    required this.sectionId,
    required this.semesterId,
    this.semesterName,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // خلفية متدرجة بسيطة بنفس لون التطبيق
        gradient: LinearGradient(
          colors: [kprimeryColor, kDarkPrimaryColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kprimeryColor.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // عنصر ديكوري خلفي ناعم
          Positioned(
            left: -20,
            bottom: -20,
            child: CircleAvatar(
              radius: 65,
              backgroundColor: kwhiteColor.withOpacity(0.06),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- الجزء العلوي: العنوان والتفاصيل مع الأيقونة ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.greenAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'إدارة الطلاب',
                                style: TextStyle(
                                  color: kwhiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'متابعة الدرجات ورصد الحضور والغياب اليومي بكل سهولة.',
                            style: TextStyle(
                              color: kwhiteColor.withOpacity(0.85),
                              fontSize: 12.5,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // أيقونة المجموعة بتصميم دائري عصري
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kwhiteColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: kwhiteColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        size: 32,
                        color: kwhiteColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // --- الجزء السفلي: أزرار التفاعل المودرن ---
                Row(
                  children: [
                    // زر عرض الطلاب والدرجات
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(
                            () => ClassStudents(
                              sectionId: sectionId,
                              semesterId: semesterId,
                              semesterName: semesterName,
                              sectionName: sectionName,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kwhiteColor,
                          foregroundColor: kprimeryColor,
                          elevation: 2,
                          shadowColor: Colors.black12,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.bar_chart_rounded, size: 18),
                        label: const Text(
                          'قائمة الدرجات',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // زر أخذ الحضور (Frosted / Glass Effect)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(
                            () => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: getIt<FetchAtendanceCubit>(),
                                ),
                                BlocProvider.value(
                                  value: getIt<TakeAtendanceCubit>(),
                                ),
                              ],
                              child: ClassDetailsStudentsAttendance(
                                sectionId: sectionId,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kwhiteColor.withOpacity(0.18),
                          foregroundColor: kwhiteColor,
                          elevation: 0,
                          side: BorderSide(
                            color: kwhiteColor.withOpacity(0.4),
                            width: 1.2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.how_to_reg_rounded, size: 18),
                        label: const Text(
                          'أخذ الحضور',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
