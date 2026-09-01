import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_student_reports/fetch_student_reports.dart';

class StudentDetailsBehaviorReports extends StatelessWidget {
  final List<FetchStudentReports> reports;
  final Function(FetchStudentReports updatedReport)? onEditReport;
  final Function(FetchStudentReports reportToDelete)? onDeleteReport;

  const StudentDetailsBehaviorReports({
    super.key,
    required this.reports,
    this.onEditReport,
    this.onDeleteReport,
  });

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kwhiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'لا توجد تقارير سلوكية',
            style: TextStyle(
              fontSize: 14,
              color: ktextColor.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ktextColor.withOpacity(0.015),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: klightSecoderyColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: kseconderyColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'التقارير السلوكية',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ktextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // قائمة التقارير
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reports.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final report = reports[index];
              final isPositive = report.type?.toLowerCase() == 'positive';
              final color = isPositive ? kadditionalColor : kRedColor;
              final bgColor = isPositive
                  ? klightAdditionalColor
                  : kLightRedColor.withOpacity(0.12);
              final dateStr = report.createdAt != null
                  ? _formatDate(report.createdAt!)
                  : '';

              return _buildReportTile(
                context: context,
                report: report,
                title: report.title ?? 'تقرير سلوكي بدون عنوان',
                dateStr: dateStr,
                color: color,
                bgColor: bgColor,
                isPositive: isPositive,
              );
            },
          ),
        ],
      ),
    );
  }

  // كرت عنوان التقرير
  Widget _buildReportTile({
    required BuildContext context,
    required FetchStudentReports report,
    required String title,
    required String dateStr,
    required Color color,
    required Color bgColor,
    required bool isPositive,
  }) {
    // التحقق مما إذا كانت حالة التقرير معلقة
    final bool isPending = report.status?.toLowerCase() == 'pending';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showReportDetailsBottomSheet(context, report, isPositive),
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              // نقطة تمييز نوع التقرير
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),

              // العنوان والتاريخ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: ktextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (dateStr.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 11,
                          color: ktextColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // شارة حالة التقرير
              _buildStatusChip(report.status),
              const SizedBox(width: 8),

              // أيقونة النقاط الثلاث: تظهر دائماً، والتعديل فقط للمعلّق والحذف للكل
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: ktextColor.withOpacity(0.6),
                  size: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditReportModal(context, report);
                  } else if (value == 'delete') {
                    _showDeleteConfirmationDialog(context, report);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  // ✏️ تعديل (فقط للتقارير المعلقة)
                  if (isPending)
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: const [
                          Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: kprimeryColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'تعديل',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: ktextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // 🗑️ حذف (دائماً)
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: kRedColor,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'حذف',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: kRedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // شارة حالة التقرير
  Widget _buildStatusChip(String? status) {
    final lower = status?.toLowerCase();

    Color color;
    Color bgColor;
    String label;

    if (lower == 'pending') {
      color = kseconderyColor;
      bgColor = klightSecoderyColor;
      label = 'معلق';
    } else if (lower == 'reviewed' || lower == 'completed') {
      color = kadditionalColor;
      bgColor = klightAdditionalColor;
      label = 'تمت المراجعة';
    } else if (lower == 'rejected' || lower == 'cancelled') {
      color = kRedColor;
      bgColor = kLightRedColor.withOpacity(0.12);
      label = 'مرفوض';
    } else {
      color = kDarkPrimaryColor;
      bgColor = klightPrimeryColor;
      label = 'قيد المراجعة';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ✏️ واجهة تعديل التقرير (BottomSheet)
  void _showEditReportModal(BuildContext context, FetchStudentReports report) {
    final titleController = TextEditingController(text: report.title ?? '');
    final contentController = TextEditingController(
      text: report.description ?? '',
    );
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: kwhiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: ktextColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: klightPrimeryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_note_rounded,
                            color: kprimeryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'تعديل التقرير السلوكي',
                          style: TextStyle(
                            color: ktextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'عنوان التقرير',
                      style: TextStyle(
                        color: ktextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: titleController,
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? 'يرجى كتابة العنوان'
                          : null,
                      decoration: InputDecoration(
                        fillColor: kbackgroundColor.withOpacity(0.5),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: ktextColor.withOpacity(0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: ktextColor.withOpacity(0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: kprimeryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'تفاصيل التقرير',
                      style: TextStyle(
                        color: ktextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: contentController,
                      maxLines: 4,
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? 'يرجى كتابة التفاصيل'
                          : null,
                      decoration: InputDecoration(
                        fillColor: kbackgroundColor.withOpacity(0.5),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: ktextColor.withOpacity(0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: ktextColor.withOpacity(0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: kprimeryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: BorderSide(
                                color: ktextColor.withOpacity(0.2),
                              ),
                            ),
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(
                                color: ktextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                if (onEditReport != null) {
                                  // تمرير النسخة المحدثة من التقرير
                                  onEditReport!(
                                    FetchStudentReports(
                                      id: report.id,
                                      teacherId: report.teacherId,
                                      studentId: report.studentId,
                                      sectionId: report.sectionId,
                                      title: titleController.text.trim(),
                                      description: contentController.text
                                          .trim(),
                                      status: report.status,
                                      academicYearId: report.academicYearId,
                                      createdAt: report.createdAt,
                                      updatedAt: report.updatedAt,
                                      teacher: report.teacher,
                                      student: report.student,
                                      section: report.section,
                                      type: report.type,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kprimeryColor,
                              foregroundColor: kwhiteColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'حفظ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 🗑️ واجهة تأكيد الحذف المميزة والاحترافية
  void _showDeleteConfirmationDialog(
    BuildContext context,
    FetchStudentReports report,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: kwhiteColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // أيقونة الحذف مع الدائرة الخارجية المضيئة
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: kLightRedColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: kRedColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'تأكيد الحذف',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ktextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'هل أنت تأكد من رغبتك في حذف هذا التقرير؟ لا يمكنك التراجع عن هذه الخطوة لاحقاً.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: ktextColor.withOpacity(0.6),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            side: BorderSide(
                              color: ktextColor.withOpacity(0.2),
                            ),
                          ),
                          child: const Text(
                            'تراجع',
                            style: TextStyle(
                              color: ktextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (onDeleteReport != null) {
                              onDeleteReport!(report);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kRedColor,
                            foregroundColor: kwhiteColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'حذف',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // واجهة تفاصيل التقرير المشروحة سابقاً
  void _showReportDetailsBottomSheet(
    BuildContext context,
    FetchStudentReports report,
    bool isPositive,
  ) {
    final activeColor = isPositive ? kadditionalColor : kRedColor;
    final activeBgColor = isPositive
        ? klightAdditionalColor
        : kLightRedColor.withOpacity(0.12);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              color: kwhiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ktextColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: activeBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPositive
                            ? Icons.thumb_up_alt_rounded
                            : Icons.warning_amber_rounded,
                        color: activeColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.title ?? 'تفاصيل التقرير السلوكي',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ktextColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isPositive
                                ? 'تقرير سلوكي إيجابي'
                                : 'تقرير سلوكي / تنبيه',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: activeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(report.status),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 16),
                const Text(
                  'تفاصيل التقرير:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: ktextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kbackgroundColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: ktextColor.withOpacity(0.08)),
                  ),
                  child: Text(
                    report.description ?? 'لا توجد تفاصيل إضافية لهذا التقرير.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: ktextColor.withOpacity(0.85),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (report.createdAt != null)
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: ktextColor.withOpacity(0.5),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'تاريخ التقرير: ${_formatFullDate(report.createdAt!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: ktextColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kprimeryColor,
                      foregroundColor: kwhiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'اليوم';
    if (diff.inDays == 1) return 'منذ يوم';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatFullDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}
