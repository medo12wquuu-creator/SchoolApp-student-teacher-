import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';

enum EntryType { note, report }

class StudentDetailsAddNoteOrReport extends StatefulWidget {
  final EntryType type;
  final String studentName;

  const StudentDetailsAddNoteOrReport({
    super.key,
    required this.type,
    required this.studentName,
  });

  @override
  State<StudentDetailsAddNoteOrReport> createState() =>
      _StudentDetailsAddNoteOrReportState();
}

class _StudentDetailsAddNoteOrReportState
    extends State<StudentDetailsAddNoteOrReport> {
  final TextEditingController _titleController =
      TextEditingController(); // 💡 متحكم عنوان التقرير
  final TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // خاص بالملاحظة فقط: true للإيجابية، false للسلبية
  bool _isPositive = true;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isNote = widget.type == EntryType.note;

    // تخصيص اللون الأساسي بناءً على نوع الواجهة
    final Color activeColor = isNote ? kadditionalColor : kprimeryColor;
    final Color activeLightColor = isNote
        ? klightAdditionalColor
        : klightPrimeryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
          top: 24,
          left: 20,
          right: 20,
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
              24, // لتجنب تغطية الكيبورد
        ),
        decoration: const BoxDecoration(
          color: kwhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // مؤشر السحب العلوي
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ktextColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // العنوان الرئيسي
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: activeLightColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isNote
                            ? Icons.bookmark_add_rounded
                            : Icons.analytics_rounded,
                        color: activeColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isNote ? 'إضافة ملاحظة أكاديمية' : 'إضافة تقرير سلوكي',
                      style: const TextStyle(
                        color: ktextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'للطالب: ${widget.studentName}',
                  style: TextStyle(
                    color: ktextColor.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),

                // تخصيص نوع الملاحظة (إيجابية / سلبية) - يظهر فقط للملاحظة
                if (isNote) ...[
                  const Text(
                    'نوع الملاحظة',
                    style: TextStyle(
                      color: ktextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // زر إيجابية
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPositive = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isPositive
                                  ? Colors.green.withOpacity(0.1)
                                  : kwhiteColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _isPositive
                                    ? Colors.green
                                    : ktextColor.withOpacity(0.15),
                                width: _isPositive ? 1.8 : 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.thumb_up_alt_rounded,
                                  color: _isPositive
                                      ? Colors.green
                                      : ktextColor.withOpacity(0.4),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'إيجابية',
                                  style: TextStyle(
                                    color: _isPositive
                                        ? Colors.green
                                        : ktextColor.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // زر سلبية
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPositive = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isPositive
                                  ? Colors.red.withOpacity(0.1)
                                  : kwhiteColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: !_isPositive
                                    ? Colors.red
                                    : ktextColor.withOpacity(0.15),
                                width: !_isPositive ? 1.8 : 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.thumb_down_alt_rounded,
                                  color: !_isPositive
                                      ? Colors.red
                                      : ktextColor.withOpacity(0.4),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'سلبية',
                                  style: TextStyle(
                                    color: !_isPositive
                                        ? Colors.red
                                        : ktextColor.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // 🌟 حقل عنوان التقرير (يظهر فقط إذا كان النوع تقريراً)
                if (!isNote) ...[
                  const Text(
                    'عنوان التقرير',
                    style: TextStyle(
                      color: ktextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _titleController,
                    validator: (value) {
                      if (!isNote && (value == null || value.trim().isEmpty)) {
                        return 'الرجاء كتابة عنوان التقرير';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText:
                          'مثال: عدم الالتزام بالزي المدرسي، المبادرة الممتازة...',
                      hintStyle: TextStyle(
                        color: ktextColor.withOpacity(0.4),
                        fontSize: 13.5,
                      ),
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
                        borderSide: BorderSide(color: activeColor, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // حقل إدخال المحتوى (مشترك بين الملاحظة والتقرير)
                Text(
                  isNote ? 'محتوى الملاحظة' : 'تفاصيل التقرير السلوكي',
                  style: const TextStyle(
                    color: ktextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _contentController,
                  maxLines: 4,
                  maxLength: 300,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء كتابة المحتوى أولاً';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: isNote
                        ? 'اكتب الملاحظة الأكاديمية هنا...'
                        : 'اكتب تفاصيل التقرير السلوكي هنا...',
                    hintStyle: TextStyle(
                      color: ktextColor.withOpacity(0.4),
                      fontSize: 13.5,
                    ),
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
                      borderSide: BorderSide(color: activeColor, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // أزرار التحكم (حفظ وإلغاء)
                Row(
                  children: [
                    // زر إلغاء
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(color: ktextColor.withOpacity(0.2)),
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
                    // زر حفظ
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final content = _contentController.text.trim();
                            final title = _titleController.text.trim();
                            final isPositiveNote = _isPositive;

                            // إرجاع البيانات المحفوظة
                            Navigator.pop(context, {
                              'type': widget.type,
                              'content': content,
                              if (!isNote)
                                'title':
                                    title, // إرجاع العنوان فقط إذا كان تقريراً
                              if (isNote) 'isPositive': isPositiveNote,
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: activeColor,
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
  }
}
