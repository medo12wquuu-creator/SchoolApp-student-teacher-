import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/widgets/app_snack_bar.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/fetch_attendance/student.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_fetch_Attendance/fetch_atendance_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_take_Attendance/cubit/take_atendance_cubit.dart';

class ClassDetailsStudentsAttendance extends StatefulWidget {
  final String sectionId;

  const ClassDetailsStudentsAttendance({
    super.key,
    required this.sectionId,
  });

  @override
  State<ClassDetailsStudentsAttendance> createState() =>
      _ClassDetailsStudentsAttendanceState();
}

class _ClassDetailsStudentsAttendanceState
    extends State<ClassDetailsStudentsAttendance> {
  // 🆕 وضع التعديل: يسمح بتعديل حضور تم تسجيله مسبقاً (نفس الـ API والموديل)
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    context.read<FetchAtendanceCubit>().fetchAttendance(
      sectionId: widget.sectionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // خلفية ناعمة وعصرية جداً
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: kwhiteColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: ktextColor, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          title: const Text(
            'سجل الحضور والغياب',
            style: TextStyle(
              color: ktextColor,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocListener<TakeAtendanceCubit, TakeAtendanceState>(
          listener: (context, state) {
            if (state is TakeAtendanceSuccess) {
              // 🆕 بعد نجاح الحفظ: الخروج من وضع التعديل وإعادة الجلب
              if (mounted) setState(() => _isEditing = false);
              context.read<FetchAtendanceCubit>().fetchAttendance(
                sectionId: widget.sectionId,
              );
              showAppSuccessSnackBar(context, 'تم حفظ جدول الحضور بنجاح');
            }
            if (state is TakeAtendanceFailure) {
              showAppErrorSnackBar(context, state.errMassage, title: 'تعذر الحفظ');
            }
          },
          child: BlocBuilder<FetchAtendanceCubit, FetchAtendanceState>(
            builder: (context, state) {
              if (state is FetchAtendanceLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: kprimeryColor,
                    strokeWidth: 3,
                  ),
                );
              }
              if (state is FetchAtendanceFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 48, color: kRedColor.withOpacity(0.8)),
                      const SizedBox(height: 12),
                      Text(
                        state.errMassage,
                        style: const TextStyle(
                          color: kRedColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is FetchAtendanceSuccess) {
                final bool editable = state.data.session == null;
                return Stack(
                  children: [
                    _buildAttendanceScreen(state, editable),
                    if (context.watch<TakeAtendanceCubit>().state is TakeAtendanceLoading)
                      Container(
                        color: Colors.black.withOpacity(0.25),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: kwhiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const CircularProgressIndicator(
                              color: kprimeryColor,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceScreen(FetchAtendanceSuccess state, bool editable) {
    final students = state.studentsList;
    final attendanceStatus = state.attendanceStatus;

    int presentCount = attendanceStatus.values.where((v) => v).length;
    int absentCount = attendanceStatus.values.where((v) => !v).length;

    // 🆕 وضع التعديل يسمح بالتعديل حتى لو كان الحضور مسجلاً مسبقاً
    final bool canEdit = editable || _isEditing;

    return Column(
      children: [
        const SizedBox(height: 8),
        if (!editable && !_isEditing)
          _buildReadOnlyBanner(),
        if (_isEditing)
          _buildEditingBanner(),
        
        // إحصائيات علوية بتصميم Modern Dashboard Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            children: [
              _buildModernStatCard(
                title: 'الحاضرون',
                count: presentCount,
                color: kadditionalColor,
                bgColor: const Color(0xFFE8F5E9),
                icon: Icons.how_to_reg_rounded,
              ),
              const SizedBox(width: 12),
              _buildModernStatCard(
                title: 'الغائبون',
                count: absentCount,
                color: kRedColor,
                bgColor: const Color(0xFFFFEBEE),
                icon: Icons.person_off_rounded,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),

        // قائمة الطلاب
        Expanded(
          child: students.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open_rounded, size: 60, color: ktextColor.withOpacity(0.2)),
                      const SizedBox(height: 12),
                      Text(
                        'لا يوجد طلاب في هذه الشعبة حالياً',
                        style: TextStyle(
                          color: ktextColor.withOpacity(0.5),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  itemCount: students.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final student = students[index];
                    if (student.id == null) return const SizedBox.shrink();
                    final isPresent = attendanceStatus[student.id] ?? true;
                    return _buildModernStudentCard(student, isPresent, canEdit);
                  },
                ),
        ),

        if (canEdit) _buildFloatingBottomBar(state, isEditingMode: _isEditing),
      ],
    );
  }

  // 🆕 بانر وضع العرض (الحضور مسجل مسبقاً) مع زر تعديل
  Widget _buildReadOnlyBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade50, Colors.orange.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_clock_rounded, color: Colors.amber.shade900, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'تم تسجيل الحضور لهذا اليوم مسبقاً',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: Colors.black87,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => setState(() => _isEditing = true),
            icon: const Icon(Icons.edit_rounded, size: 16, color: kprimeryColor),
            label: const Text(
              'تعديل الحضور',
              style: TextStyle(
                color: kprimeryColor,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🆕 بانر وضع التعديل
  Widget _buildEditingBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [klightPrimeryColor, const Color(0xFFE3EEFF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kprimeryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: kprimeryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit_rounded, color: kprimeryColor, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'وضع التعديل: اضغط على الطالب لتغيير حالته ثم اضغط حفظ التعديلات',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: ktextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // كرت الإحصائيات الحديث
  Widget _buildModernStatCard({
    required String title,
    required int count,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kwhiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: ktextColor.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$count',
                  style: TextStyle(
                    color: ktextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // كرت الطالب العصري جداً بأزرار التبديل الناعمة
  Widget _buildModernStudentCard(Student student, bool isPresent, bool editable) {
    final person = student.user?.person;
    final String firstName = student.firstName ?? person?.firstName ?? '';
    final String lastName = student.lastName ?? person?.lastName ?? '';

    final name = '$firstName $lastName'.trim();
    final initials = name.isNotEmpty
        ? name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('')
        : '??';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPresent
              ? Colors.transparent
              : kRedColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: (student.id == null)
              ? null
              // 🆕 وضع التعديل أولاً (بـ force حتى لو كانت الجلسة مسجلة)
              : _isEditing
              ? () => context.read<FetchAtendanceCubit>().toggleAttendance(
                    student.id!,
                    force: true,
                  )
              : editable
              ? () => context.read<FetchAtendanceCubit>().toggleAttendance(
                    student.id!,
                  )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // صورة الطالب العصرية (Avatar)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isPresent
                          ? [kprimeryColor.withOpacity(0.15), kprimeryColor.withOpacity(0.05)]
                          : [kRedColor.withOpacity(0.15), kRedColor.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: isPresent ? kprimeryColor : kRedColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                
                // اسم الطالب والمعلومات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isNotEmpty ? name : 'طالب رقم ${student.id}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: ktextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'المعرف: #${student.id}',
                        style: TextStyle(
                          fontSize: 11,
                          color: ktextColor.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // زر حالة الحضور العصري (Interactive Badge/Pill)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isPresent ? klightAdditionalColor : kLightRedColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        size: 16,
                        color: isPresent ? kadditionalColor : kRedColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isPresent ? 'حاضر' : 'غائب',
                        style: TextStyle(
                          fontSize: 12,
                          color: isPresent ? kadditionalColor : kRedColor,
                          fontWeight: FontWeight.w800,
                        ),
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

  // شريط الأزرار السفلي بتصميم عصري عائم (Floating Action Bottom Bar)
  Widget _buildFloatingBottomBar(
    FetchAtendanceSuccess state, {
    bool isEditingMode = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // زر الحفظ الرئيسي مع تأثير التدرج والظل
            Expanded(
              flex: 2,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kprimeryColor, Color(0xFF3B82F6)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: kprimeryColor.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final studentsList = state.attendanceStatus.entries.map((e) {
                      return {
                        'student_id': e.key,
                        'status': e.value ? 'present' : 'absent',
                      };
                    }).toList();

                    context.read<TakeAtendanceCubit>().submitAttendance(
                          sectionId: widget.sectionId,
                          attendances: studentsList,
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_rounded, color: kwhiteColor, size: 20),
                      SizedBox(width: 8),
                      Text(
                        isEditingMode ? 'حفظ التعديلات' : 'حفظ الحضور',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: kwhiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // زر الإلغاء الأنيق
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: isEditingMode
                      ? () => setState(() => _isEditing = false)
                      : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ktextColor.withOpacity(0.15), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isEditingMode ? 'إلغاء التعديل' : 'إلغاء',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: ktextColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}