
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_send_report/send_class_report_cubit.dart';


class ClassDetailsAddClassReport extends StatefulWidget {
  final String sectionId;

  const ClassDetailsAddClassReport({super.key, required this.sectionId});

  @override
  State<ClassDetailsAddClassReport> createState() =>
      _ClassDetailsAddClassReportState();
}

class _ClassDetailsAddClassReportState
    extends State<ClassDetailsAddClassReport> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      getIt<SendClassReportCubit>().sendClassReport(
        sectionId: widget.sectionId,
        title: _titleController.text.trim(),
        description: _contentController.text.trim(),
        type: 'class_report',
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    bool isAlignTop = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(color: ktextColor.withOpacity(0.4), fontSize: 13),
      labelStyle: const TextStyle(color: ktextColor, fontSize: 14),
      alignLabelWithHint: isAlignTop,
      filled: true,
      fillColor: klightPrimeryColor.withOpacity(0.3),
      prefixIcon: isAlignTop
          ? Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Icon(prefixIcon, color: kprimeryColor),
            )
          : Icon(prefixIcon, color: kprimeryColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: ktextColor.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: kprimeryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: kRedColor, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocProvider.value(
      value: getIt<SendClassReportCubit>(),
      child: BlocListener<SendClassReportCubit, SendClassReportState>(
        listener: (context, state) {
          if (state is SendClassReportLoading) {
            setState(() => _isLoading = true);
          } else if (state is SendClassReportSuccess) {
            setState(() => _isLoading = false);
            Navigator.pop(context, true);
            Get.snackbar(
              'نجاح',
              state.message ?? 'تم إضافة التقرير بنجاح',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: kadditionalColor,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 14,
            );
          } else if (state is SendClassReportFailure) {
            setState(() => _isLoading = false);
            Get.snackbar(
              'خطأ',
              state.errMassage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: kRedColor,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 14,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            decoration: const BoxDecoration(
              color: kwhiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: ktextColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kLightRedColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.note_add_rounded,
                            color: kRedColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'إضافة تقرير جديد عن الشعبة',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: ktextColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Inputs
                    TextFormField(
                      controller: _titleController,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'يرجى إدخال عنوان التقرير'
                          : null,
                      decoration: _buildInputDecoration(
                        labelText: 'عنوان التقرير',
                        hintText: 'مثال: تقرير السلوك العام / صيانة القاعة',
                        prefixIcon: Icons.title_rounded,
                      ),
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _contentController,
                      maxLines: 4,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'يرجى كتابة تفاصيل التقرير'
                          : null,
                      decoration: _buildInputDecoration(
                        labelText: 'تفاصيل ومحتوى التقرير',
                        hintText: 'اكتب الملاحظات أو التقارير بالتفصيل هنا...',
                        prefixIcon: Icons.description_outlined,
                        isAlignTop: true,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: kRedColor.withOpacity(0.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(
                                color: kRedColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitReport,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kRedColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'إضافة التقرير',
                                    style: TextStyle(
                                      color: kwhiteColor,
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
            ),
          ),
        ),
      ),
    );
  }
}
