import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/helpers/photo_url.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/views/login.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/models/fetch_teacher_profile_model/fetch_teacher_profile_model.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/fetch_teacher_profile_info/fetch_profile_info_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_profile/presentation/view_models/edit_password/send_new_password_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_profile/presentation/view_models/send_profile_info/send_teacher_profile_info_cubit.dart';
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';
 
class TeacherProfileHome extends StatefulWidget {
  final FetchTeacherProfileModel? profileModel;

  const TeacherProfileHome({super.key, this.profileModel});

  @override
  State<TeacherProfileHome> createState() => _TeacherProfileHomeScreenState();
}

class _TeacherProfileHomeScreenState extends State<TeacherProfileHome> {
  bool isEditModeActive = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  bool isEditingPhone = false;
  bool isEditingEmail = false;

  // البيانات التي سيتم عرضها وتعديلها
  String fullName = 'جاري التحميل...';
  String birthDate = 'غير محدد';
  String email = 'غير محدد';
  String phone = 'غير محدد';
  String? personalPhotoUrl;
  DateTime? _photoUpdatedAt;

  // متغيرات مؤقتة لحفظ التعديلات الجديدة قبل اعتمادها بالكامل
  String tempPhone = 'غير محدد';
  String tempEmail = 'غير محدد';

  late TextEditingController phoneController;
  late TextEditingController emailController;

  final _phoneFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    emailController = TextEditingController();

    if (widget.profileModel != null) {
      _extractAndAssignData(widget.profileModel!);
    }
  }

  void _extractAndAssignData(FetchTeacherProfileModel model) {
    final user = model.teacher?.employee?.user;
    final person = user?.person;

    final firstName = person?.firstName ?? '';
    final lastName = person?.lastName ?? '';
    fullName = '$firstName $lastName'.trim();
    if (fullName.isEmpty) fullName = 'غير متوفر';

    birthDate = person?.birthdate ?? 'غير محدد';
    email = user?.email ?? 'غير محدد';
    phone = user?.phoneNumber ?? 'غير محدد';
    personalPhotoUrl = person?.personalPhoto;
    _photoUpdatedAt = person?.updatedAt;

    tempEmail = email;
    tempPhone = phone;

    phoneController.text = phone;
    emailController.text = email;
  }

  bool get hasChanges {
    return _selectedImage != null || tempEmail != email || tempPhone != phone;
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر اختيار الصورة من المعرض',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void _saveAllChanges() {
    final cubit = getIt<SendTeacherProfileInfoCubit>();
    cubit.sendProfileInfo(
      phone: tempPhone,
      email: tempEmail,
      photoFile: _selectedImage,
    );
  }

  void _cancelEditMode() {
    setState(() {
      isEditModeActive = false;
      isEditingPhone = false;
      isEditingEmail = false;
      _selectedImage = null;
      tempEmail = email;
      tempPhone = phone;
      emailController.text = email;
      phoneController.text = phone;
    });
  }

  // 🟢 دالة إظهار الـ Bottom Sheet الخاصة بتغيير كلمة المرور مع معالجة خطأ كلمة المرور القديمة
  void _showChangePasswordBottomSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return BlocConsumer<SendNewPasswordCubit, SendNewPasswordState>(
          bloc: getIt<SendNewPasswordCubit>(),
          listener: (context, state) {
            if (state is SendNewPasswordSuccess) {
              Navigator.pop(modalContext);
              Get.snackbar(
                'نجاح',
                state.message ?? 'تم تغيير كلمة المرور بنجاح',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            } else if (state is SendNewPasswordFailure) {
              String errorMessage = state.errMassage;

              // تخصيص النص في حال كان الخطأ متعلقاً بكلمة المرور القديمة
              if (errorMessage.toLowerCase().contains("old password") ||
                  errorMessage.toLowerCase().contains("current password") ||
                  errorMessage.contains("غير متطابقة") ||
                  errorMessage.toLowerCase().contains("incorrect")) {
                errorMessage =
                    "كلمة المرور القديمة غير صحيحة، يرجى التثبت وإعادة المحاولة.";
              }

              Get.snackbar(
                'خطأ',
                errorMessage,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
                duration: const Duration(seconds: 4),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is SendNewPasswordLoading;

            return StatefulBuilder(
              builder: (context, setModalState) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: kwhiteColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 48,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: klightPrimeryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.lock_reset_rounded,
                                      color: kprimeryColor,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "تغيير كلمة المرور",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: ktextColor,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "يرجى إدخال كلمة المرور الحالية والجديدة",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              _buildPasswordField(
                                controller: oldPasswordController,
                                label: "كلمة المرور القديمة",
                                obscureText: obscureOld,
                                onToggleVisibility: () {
                                  setModalState(() {
                                    obscureOld = !obscureOld;
                                  });
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'يرجى إدخال كلمة المرور القديمة';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              _buildPasswordField(
                                controller: newPasswordController,
                                label: "كلمة المرور الجديدة",
                                obscureText: obscureNew,
                                onToggleVisibility: () {
                                  setModalState(() {
                                    obscureNew = !obscureNew;
                                  });
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'يرجى إدخال كلمة المرور الجديدة';
                                  }
                                  if (val.length < 6) {
                                    return 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              _buildPasswordField(
                                controller: confirmPasswordController,
                                label: "تأكيد كلمة المرور الجديدة",
                                obscureText: obscureConfirm,
                                onToggleVisibility: () {
                                  setModalState(() {
                                    obscureConfirm = !obscureConfirm;
                                  });
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'يرجى تأكيد كلمة المرور الجديدة';
                                  }
                                  if (val != newPasswordController.text) {
                                    return 'كلمات المرور غير متطابقة';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 28),

                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  getIt<SendNewPasswordCubit>()
                                                      .sendNewPassword(
                                                        currentPassword:
                                                            oldPasswordController
                                                                .text,
                                                        newPassword:
                                                            newPasswordController
                                                                .text,
                                                        newPasswordConfirmation:
                                                            confirmPasswordController
                                                                .text,
                                                      );
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kprimeryColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : const Text(
                                                "حفظ كلمة المرور",
                                                style: TextStyle(
                                                  color: kwhiteColor,
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            Navigator.pop(modalContext),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade100,
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "إلغاء",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: ktextColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: kprimeryColor,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: onToggleVisibility,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        fillColor: klightPrimeryColor.withOpacity(0.3),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kprimeryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kRedColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kRedColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (_selectedImage != null) {
      return CircleAvatar(
        radius: 56,
        backgroundColor: klightPrimeryColor,
        backgroundImage: FileImage(_selectedImage!),
      );
    }

    final photoUrl = cacheBustedPhotoUrl(personalPhotoUrl, _photoUpdatedAt);
    if (photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 56,
        backgroundColor: klightPrimeryColor,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            width: 112,
            height: 112,
            fit: BoxFit.cover,
            httpHeaders: const {
              'ngrok-skip-browser-warning': 'true',
              'User-Agent': 'flutter-app',
            },
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.person,
              size: 50,
              color: kprimeryColor,
            ),
          ),
        ),
      );
    }

    return const CircleAvatar(
      radius: 56,
      backgroundColor: klightPrimeryColor,
      child: Icon(Icons.person, size: 50, color: kprimeryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SendTeacherProfileInfoCubit>(),
      child: BlocProvider.value(
        value: getIt<FetchProfileInfoCubit>(),
        child: BlocProvider.value(
          value: getIt<SendNewPasswordCubit>(),
          child: BlocListener<SendTeacherProfileInfoCubit, SendTeacherProfileInfoState>(
            listener: (context, state) {
              if (state is SendTeacherProfileInfoSuccess) {
                setState(() {
                  email = tempEmail;
                  phone = tempPhone;
                  isEditModeActive = false;
                  isEditingPhone = false;
                  isEditingEmail = false;
                  // نُبقي الصورة المختارة معروضة حتى تصل البيانات الجديدة من السيرفر
                });
                // 🆕 إعادة جلب البروفايل بعد الحفظ ليتم تحديث الصورة في الهوم والبروفايل
                getIt<FetchProfileInfoCubit>().fetchProfileInfo();
                Get.snackbar(
                  'نجاح',
                  state.message ?? 'تم حفظ التعديلات بنجاح',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else if (state is SendTeacherProfileInfoFailure) {
                Get.snackbar(
                  'خطأ',
                  state.errMassage,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
            child: BlocListener<FetchProfileInfoCubit, FetchProfileInfoState>(
              listener: (context, state) {
                if (state is FetchProfileInfoSuccess) {
                  setState(() {
                    _extractAndAssignData(state.profile);
                    // 🆕 بعد وصول البيانات الجديدة نستبدل المعاينة المحلية بالرابط الجديد
                    _selectedImage = null;
                  });
                }
              },
              child: BlocBuilder<FetchProfileInfoCubit, FetchProfileInfoState>(
                builder: (context, state) {
                  if (state is FetchProfileInfoSuccess &&
                      widget.profileModel == null) {
                    _extractAndAssignData(state.profile);
                  }

                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: Scaffold(
                      backgroundColor: kbackgroundColor,
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            // --- 1. الهيدر ---
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  height: 240,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        kprimeryColor,
                                        kDarkPrimaryColor,
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(36),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  top: -40,
                                  right: -30,
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kwhiteColor.withOpacity(0.08),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: -40,
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kwhiteColor.withOpacity(0.06),
                                    ),
                                  ),
                                ),

                                // زر العودة
                                Positioned(
                                  top: 45,
                                  right: 16,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: kwhiteColor,
                                      size: 22,
                                    ),
                                    onPressed: () => Get.back(),
                                  ),
                                ),

                                // صورة المعلم والمعلومات الأساسية
                                Positioned(
                                  top: 40,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: isEditModeActive
                                            ? _pickImageFromGallery
                                            : null,
                                        child: Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: kwhiteColor.withOpacity(
                                                  0.25,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  3.5,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: kwhiteColor,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 12,
                                                      offset: Offset(0, 5),
                                                    ),
                                                  ],
                                                ),
                                                child: _buildAvatarImage(),
                                              ),
                                            ),
                                            if (isEditModeActive)
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: kprimeryColor,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: kwhiteColor,
                                                    width: 2,
                                                  ),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.camera_alt_rounded,
                                                  color: kwhiteColor,
                                                  size: 18,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        fullName,
                                        style: const TextStyle(
                                          color: kwhiteColor,
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        "مدرس مادة",
                                        style: TextStyle(
                                          color: kwhiteColor.withOpacity(0.9),
                                          fontSize: 13.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // --- 2. كرت المعلومات ---
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              child: Card(
                                elevation: 1.5,
                                shadowColor: kprimeryColor.withOpacity(0.15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                color: kwhiteColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      // تاريخ الميلاد
                                      _buildInfoRow(
                                        icon: Icons.cake_outlined,
                                        title: "تاريخ الميلاد",
                                        value: birthDate,
                                        canEdit: false,
                                      ),
                                      const Divider(
                                        height: 28,
                                        color: Color(0xffF0F4F8),
                                      ),

                                      // البريد الإلكتروني
                                      isEditingEmail
                                          ? _buildEditField(
                                              controller: emailController,
                                              label: "البريد الإلكتروني الرسمي",
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              onSave: () {
                                                setState(() {
                                                  tempEmail =
                                                      emailController.text;
                                                  isEditingEmail = false;
                                                });
                                              },
                                              onCancel: () {
                                                setState(() {
                                                  emailController.text =
                                                      tempEmail;
                                                  isEditingEmail = false;
                                                });
                                              },
                                            )
                                          : _buildInfoRow(
                                              icon: Icons.email_outlined,
                                              title: "البريد الإلكتروني الرسمي",
                                              value: tempEmail,
                                              canEdit: isEditModeActive,
                                              onEditPressed: () {
                                                setState(() {
                                                  isEditingEmail = true;
                                                });
                                              },
                                            ),
                                      const Divider(
                                        height: 28,
                                        color: Color(0xffF0F4F8),
                                      ),

                                      // رقم الهاتف
                                      isEditingPhone
                                          ? Form(
                                              key: _phoneFormKey,
                                              child: _buildEditField(
                                                controller: phoneController,
                                                label: "رقم الهاتف",
                                                keyboardType:
                                                    TextInputType.phone,
                                                maxLength: 10,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                validator: (val) {
                                                  if (val == null ||
                                                      val.isEmpty) {
                                                    return 'الرجاء إدخال الرقم';
                                                  }
                                                  if (val.length > 10) {
                                                    return 'الرقم يجب ألا يتجاوز 10 أرقام';
                                                  }
                                                  return null;
                                                },
                                                onSave: () {
                                                  if (_phoneFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      tempPhone =
                                                          phoneController.text;
                                                      isEditingPhone = false;
                                                    });
                                                  }
                                                },
                                                onCancel: () {
                                                  setState(() {
                                                    phoneController.text =
                                                        tempPhone;
                                                    isEditingPhone = false;
                                                  });
                                                },
                                              ),
                                            )
                                          : _buildInfoRow(
                                              icon: Icons.phone_outlined,
                                              title: "رقم الهاتف",
                                              value: tempPhone,
                                              canEdit: isEditModeActive,
                                              onEditPressed: () {
                                                setState(() {
                                                  isEditingPhone = true;
                                                });
                                              },
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // --- 3. الأزرار ---
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              child: Column(
                                children: [
                                  // زر تغيير كلمة المرور يظهر فقط إذا لم يكن وضع التعديل فعالاً
                                  if (!isEditModeActive) ...[
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton.icon(
                                        onPressed: () =>
                                            _showChangePasswordBottomSheet(
                                              context,
                                            ),
                                        icon: const Icon(
                                          Icons.lock_reset_rounded,
                                          color: kwhiteColor,
                                          size: 22,
                                        ),
                                        label: const Text(
                                          "تغيير كلمة المرور",
                                          style: TextStyle(
                                            color: kwhiteColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kprimeryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],

                                  // زر طلب التعديل أو صف أزرار الحفظ والإلغاء
                                  if (!isEditModeActive)
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            isEditModeActive = true;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.edit_note_rounded,
                                          color: kprimeryColor,
                                        ),
                                        label: const Text(
                                          "طلب تعديل البيانات الشخصية",
                                          style: TextStyle(
                                            color: kprimeryColor,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: klightPrimeryColor
                                              .withOpacity(0.5),
                                          side: BorderSide(
                                            color: kprimeryColor.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Row(
                                      children: [
                                        // زر حفظ التعديلات
                                        Expanded(
                                          child: SizedBox(
                                            height: 50,
                                            child: ElevatedButton.icon(
                                              onPressed: hasChanges
                                                  ? _saveAllChanges
                                                  : null,
                                              icon: const Icon(
                                                Icons
                                                    .check_circle_outline_rounded,
                                                color: kwhiteColor,
                                                size: 20,
                                              ),
                                              label: const Text(
                                                "حفظ التعديلات",
                                                style: TextStyle(
                                                  color: kwhiteColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: kprimeryColor,
                                                disabledBackgroundColor:
                                                    Colors.grey.shade300,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        // زر إلغاء وضع التعديل
                                        Expanded(
                                          child: SizedBox(
                                            height: 50,
                                            child: OutlinedButton.icon(
                                              onPressed: _cancelEditMode,
                                              icon: const Icon(
                                                Icons.close_rounded,
                                                color: kRedColor,
                                                size: 20,
                                              ),
                                              label: const Text(
                                                "إلغاء التعديل",
                                                style: TextStyle(
                                                  color: kRedColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: kRedColor
                                                    .withOpacity(0.05),
                                                side: const BorderSide(
                                                  color: kRedColor,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  const SizedBox(height: 16),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: TextButton.icon(
                                      onPressed: () => _confirmLogout(context),
                                      icon: const Icon(
                                        Icons.logout_rounded,
                                        color: kRedColor,
                                        size: 22,
                                      ),
                                      label: const Text(
                                        "تسجيل الخروج",
                                        style: TextStyle(
                                          color: kRedColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: kRedColor.withOpacity(
                                          0.08,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل تريد تسجيل الخروج من الحساب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تسجيل خروج'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await getIt<UserCubitt>().logout();
    if (!mounted) return;
    Get.offAll(() => const Login());
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required bool canEdit,
    VoidCallback? onEditPressed,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: klightPrimeryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: kprimeryColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ktextColor.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: ktextColor,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (canEdit)
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kprimeryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: kprimeryColor,
                size: 18,
              ),
            ),
            onPressed: onEditPressed,
          ),
      ],
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onSave,
    required VoidCallback onCancel,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          validator: validator,
          autofocus: true,
          style: const TextStyle(fontSize: 14, color: ktextColor),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: kprimeryColor, fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kprimeryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kprimeryColor, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onCancel,
              child: const Text(
                "إلغاء",
                style: TextStyle(color: kRedColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: kprimeryColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "تأكيد الحقِل",
                style: TextStyle(
                  color: kwhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
