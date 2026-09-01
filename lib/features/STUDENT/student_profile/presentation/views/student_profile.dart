import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:schooly/features/STUDENT/student_profile/data/datasource/student_profile_remote_data_source.dart';
import 'package:schooly/features/STUDENT/student_profile/data/repositories/student_profile_repository.dart';
import 'package:schooly/features/STUDENT/student_profile/presentation/view_models/cubit_profile.dart';
import 'package:schooly/features/STUDENT/student_profile/presentation/view_models/state_profile.dart';
import 'package:schooly/features/STUDENT/student_profile/presentation/views/widget/edit_button.dart';
import 'package:schooly/features/STUDENT/student_profile/presentation/views/widget/info_field.dart';
import 'package:schooly/features/STUDENT/student_profile/presentation/views/widget/info_section.dart';
import 'package:schooly/features/STUDENT/student_profile/presentation/views/widget/profile_header.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentProfileCubit(
        StudentProfileRepository(
          StudentProfileRemoteDataSource(
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            ),
          ),
        ),
        context.read<UserCubit>(),
      )..loadProfile(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF7F9FB);
    final appBarBg = isDark
        ? const Color(0xFF1A1C1E).withOpacity(0.1)
        : Colors.white.withOpacity(0.1);
    final errorColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: const Text(
          'ملفي الشخصي',
          style: TextStyle(
            color: Color(0xFF1565C0),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: const [
          Icon(
            Icons.account_circle_outlined,
            color: Color(0xFF1565C0),
            size: 28,
          ),
        ],
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<StudentProfileCubit, StudentProfileState>(
            builder: (context, state) {
              if (state is StudentProfileLoading) {
                return Center(
                  child: Lottie.asset(
                    'assets/animation/profile.json',
                    width: 120,
                    height: 120,
                    repeat: true,
                  ),
                );
              }

              if (state is StudentProfileError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: errorColor),
                    ),
                  ),
                );
              }

              final profile = state is StudentProfileLoaded
                  ? state.profile
                  : state is StudentProfileUpdated
                  ? state.profile
                  : context.read<StudentProfileCubit>().profile;

              if (profile == null) {
                return const Center(child: Text('لا توجد معلومات حساب'));
              }

              // final subtitle = [
              //   if (profile.major?.isNotEmpty == true) profile.major,
              //   if (profile.gpa?.isNotEmpty == true) 'GPA: ${profile.gpa}',
              // ].whereType<String>().join(' • ');

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Column(
                  children: [
                    ProfileHeader(
                      name: profile.firstLastName,
                      subtitle: 'طالب',
                      avatarFile: profile.personalPhoto,
                      avatarUrl: profile.cleanPhotoUrl,
                    ),
                    const SizedBox(height: 40),
                    InfoSection(
                      title: 'معلومات شخصية',
                      icon: Icons.person_outline,
                      fields: [
                        InfoField(label: 'الاسم الثلاثي', value: profile.name),
                        InfoField(
                          label: 'تاريخ الولادة',
                          value: profile.birthDate ?? 'Not available',
                          icon: Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    InfoSection(
                      title: 'معلومات التواصل',
                      icon: Icons.contact_page_outlined,
                      fields: [
                        InfoField(
                          label: 'رقم الهاتف',
                          value: profile.phone ?? 'Not available',
                          icon: Icons.phone_outlined,
                        ),
                        InfoField(
                          label: 'البريد الإلكتروني',
                          value: profile.email,
                          icon: Icons.email_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    InfoSection(
                      title: 'معومات عائلية',
                      icon: Icons.family_restroom_outlined,
                      fields: [
                        InfoField(
                          label: "اسم الأب",
                          value: profile.fatherName ?? 'Not available',
                          leadingIcon: Icons.person_outline,
                        ),
                        InfoField(
                          label: "اسم الأم",
                          value: profile.motherName ?? 'Not available',
                          leadingIcon: Icons.person_outline,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: EditButton(
              onPressed: () {
                context.read<StudentProfileCubit>().refreshProfile();
              },
              label: 'تحديث البيانات',
            ),
          ),
        ],
      ),
    );
  }
}
