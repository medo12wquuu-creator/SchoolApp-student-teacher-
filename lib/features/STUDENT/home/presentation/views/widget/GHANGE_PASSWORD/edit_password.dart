import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/home/data/datasource/home_remote_data_source.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/GHANGE_PASSWORD/password_field.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/widget/GHANGE_PASSWORD/update_password_buttom.dart';

void showChangePasswordSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const ChangePasswordSheet(),
  );
}

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool _isUpdating = false;
  bool oldVisible = false;
  bool newVisible = false;
  bool confirmVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "تغيير كلمة المرور",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 20),

          PasswordField(
            label: "كلمة المرور القديمة",
            controller: oldPassController,
            visible: oldVisible,
            onToggle: () => setState(() => oldVisible = !oldVisible),
          ),
          const SizedBox(height: 16),

          PasswordField(
            label: "كلمة المرور الجديدة",
            controller: newPassController,
            visible: newVisible,
            onToggle: () => setState(() => newVisible = !newVisible),
          ),
          const SizedBox(height: 16),

          PasswordField(
            label: "تأكيد كلمة المرور الجديدة",
            controller: confirmPassController,
            visible: confirmVisible,
            onToggle: () => setState(() => confirmVisible = !confirmVisible),
          ),
          const SizedBox(height: 24),

          UpdatePasswordButton(
            isLoading: _isUpdating,
            onPressed: () async {
              final oldPass = oldPassController.text.trim();
              final newPass = newPassController.text.trim();
              final confirmPass = confirmPassController.text.trim();

              if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('رجاء املء جميع الحقول')),
                );
                return;
              }

              if (newPass != confirmPass) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('كلمة المرور الجديدة وتأكيدها غير متطابقين'),
                  ),
                );
                return;
              }

              setState(() => _isUpdating = true);

              final token = context.read<UserCubit>().token ?? '';

              final result = await HomeRemoteDataSource(Dio()).changePassword(
                token: token,
                oldPassword: oldPass,
                newPassword: newPass,
                confirmNewPassword: confirmPass,
              );

              if (!context.mounted) return;
              setState(() => _isUpdating = false);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result["message"]?.isNotEmpty == true
                        ? result["message"].toString()
                        : (result["statusCode"] == 200
                              ? 'تم تحديث كلمة المرور بنجاح'
                              : 'فشل في تحديث كلمة المرور'),
                  ),
                  backgroundColor: result["statusCode"] == 200
                      ? Colors.green
                      : Colors.red,
                ),
              );
              if (result["statusCode"] == 200) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('نجاح'),
                    content: const Text('تم تحديث كلمة المرور بنجاح'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          Navigator.pop(
                            context,
                          ); // إغلاق الـ bottom sheet بعد الـ dialog
                        },
                        child: const Text('موافق'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
