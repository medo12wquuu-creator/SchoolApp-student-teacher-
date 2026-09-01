// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:get/get.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:schooly/features/STUDENT/home/data/datasource/home_remote_data_source.dart';
// import 'package:schooly/features/STUDENT/home/data/repositories/home_repository.dart';
// import 'package:schooly/features/STUDENT/home/presentation/view_models/home_cubit.dart';
// import 'package:schooly/features/STUDENT/home/presentation/views/student_layout.dart';
// import 'package:schooly/core/services/firebase_notification_service.dart';
// import 'package:schooly/features/STUDENT/splash/splash.dart';
// import 'package:schooly/core/theme/theme_cubit.dart';
// import 'package:schooly/core/language/language_cubit.dart';
// import 'package:schooly/core/constants/colors.constants.dart';
// import 'package:schooly/core/constants/service_locatorr.dart';
// import 'package:schooly/features/LOG&REGST/Login/data/repos/login_repo.dart';
// import 'package:schooly/features/LOG&REGST/Login/presentation/view_models/login_cubit/login_cubit.dart';
// import 'package:schooly/features/LOG&REGST/Login/presentation/views/login.dart';
// import 'package:schooly/features/STUDENT/student_user/data/datasource/user_remote_data_source.dart';
// import 'package:schooly/features/STUDENT/student_user/data/repositories/user_repository.dart';
// import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
// import 'package:schooly/core/services/firebase_options.dart';
// import 'package:showcaseview/showcaseview.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   ShowcaseView.register();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   await FirebaseNotificationService.instance.init();
//   await FirebaseNotificationService.instance.requestPermission();

//   setup();

//   await initializeDateFormatting('en_US');
//   await initializeDateFormatting('ar_SA');

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => ThemeCubit()),
//         BlocProvider(create: (_) => LanguageCubit()),

//         BlocProvider(
//           create: (_) =>
//               UserCubit(UserRepository(UserRemoteDataSource(Dio())))
//                 ..loadUser(),
//         ),

//         BlocProvider(create: (_) => LoginCubit(getIt.get<LoginRepo>())),
//       ],

//       child: BlocBuilder<ThemeCubit, ThemeMode>(
//         builder: (context, themeMode) {
//           return BlocBuilder<LanguageCubit, Locale>(
//             builder: (context, locale) {
//               return MultiBlocProvider(
//                 providers: [
//                   BlocProvider(
//                     create: (context) => HomeCubit(
//                       HomeRepository(HomeRemoteDataSource(Dio())),
//                       context.read<UserCubit>(),
//                     ),
//                   ),
//                 ],
//                 child: GetMaterialApp(
//                   locale: locale,
//                   debugShowCheckedModeBanner: false,
//                   title: 'مدرسة القمة',
//                   routes: {
//                     '/login': (_) => const Login(),
//                     '/home': (_) => const StudentMainLayout(),
//                   },
//                   themeMode: themeMode,
//                   theme: ThemeData(
//                     useMaterial3: true,
//                     colorScheme: const ColorScheme.light(
//                       primary: kprimeryColor,
//                       onPrimary: kwhiteColor,
//                       surface: kwhiteColor,
//                       onSurface: ktextColor,
//                     ),
//                     textButtonTheme: TextButtonThemeData(
//                       style: TextButton.styleFrom(
//                         foregroundColor: kprimeryColor,
//                         textStyle: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     datePickerTheme: DatePickerThemeData(
//                       headerBackgroundColor: kprimeryColor,
//                       headerForegroundColor: kwhiteColor,
//                       backgroundColor: kwhiteColor,
//                       dayShape: WidgetStateProperty.all(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                     ),
//                     dialogTheme: DialogThemeData(backgroundColor: kwhiteColor),
//                   ),
//                   darkTheme: ThemeData(
//                     useMaterial3: true,
//                     brightness: Brightness.dark,
//                     colorScheme: const ColorScheme.dark(
//                       primary: kprimeryColor,
//                       onPrimary: kwhiteColor,
//                       surface: Color(0xFF1A1C1E),
//                       onSurface: Colors.white,
//                     ),
//                     textButtonTheme: TextButtonThemeData(
//                       style: TextButton.styleFrom(
//                         foregroundColor: kprimeryColor,
//                         textStyle: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     datePickerTheme: DatePickerThemeData(
//                       headerBackgroundColor: kprimeryColor,
//                       headerForegroundColor: kwhiteColor,
//                       backgroundColor: const Color(0xFF2C2C2C),
//                       dayShape: WidgetStateProperty.all(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                     ),
//                     dialogTheme: DialogThemeData(
//                       backgroundColor: const Color(0xFF2C2C2C),
//                     ),
//                     scaffoldBackgroundColor: const Color(0xFF121212),
//                     appBarTheme: const AppBarTheme(
//                       backgroundColor: Color(0xFF1A1C1E),
//                       elevation: 0,
//                     ),
//                     cardColor: const Color(0xFF1E1E1E),
//                     dividerColor: const Color(0xFF333333),
//                   ),
//                   home: const Splash(),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/core/services/firebase_options.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_repo/student_repo.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/marks/marks_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/students/fetch_students_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/weights/weights_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/classes_repo/classes_repo.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_deails_fetch_homework/fetch_homework_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_delete_task_homework/delete_task_homework_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_fetch_tasks/fetch_task_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_send_homework/send_homework_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_send_task/send_task_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/teacher_classes/teacher_classes_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/repos/teacher_home_repo.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/today_shedual/today_schedual_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/views/teacher_home.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_quiz_score/fetch_quiz_score_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_teacher_quiz_details/fetch_teacher_quiz_details_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_teacher_quizzes/fetch_teacher_quizzes_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/send_teacher_quiz/send_teacher_quiz_cubit.dart';
import 'package:schooly/core/services/firebase_notification_service.dart';
import 'package:schooly/core/services/firebaseteacher.dart' as teacher_fcm;
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/theme/theme_cubit.dart';
import 'package:schooly/core/language/language_cubit.dart';

import 'package:schooly/features/LOG&REGST/Login/data/repos/login_repo.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/view_models/login_cubit/login_cubit.dart';
import 'package:schooly/features/LOG&REGST/Login/presentation/views/login.dart';

import 'package:schooly/features/STUDENT/home/data/datasource/home_remote_data_source.dart';
import 'package:schooly/features/STUDENT/home/data/repositories/home_repository.dart';
import 'package:schooly/features/STUDENT/home/presentation/view_models/home_cubit.dart';
import 'package:schooly/features/STUDENT/home/presentation/views/student_layout.dart';
import 'package:schooly/features/STUDENT/splash/splash.dart';
import 'package:schooly/features/STUDENT/student_user/data/datasource/user_remote_data_source.dart';
import 'package:schooly/features/STUDENT/student_user/data/repositories/user_repository.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';

void main() {
  // 🛡️ منع أي استثناء غير معالج من إيقاف التطبيق بالكامل — نلتقطه ونسجّله فقط
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      setup();
      ShowcaseView.register();

      // استثناءات غير متزامنة (async) — مثل ClientException من مكتبة pusher
      PlatformDispatcher.instance.onError = (error, stack) {
        debugPrint('🛡️ استثناء غير معالج: $error');
        return true; // نمنع إيقاف التطبيق
      };

      // استثناءات Flutter (بناء الواجهة)
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
      };

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseNotificationService.instance.init();
      await FirebaseNotificationService.instance.requestPermission();
      await teacher_fcm.FirebaseNotificationService.instance.init(); // أضف هذا
      await teacher_fcm.FirebaseNotificationService.instance
          .requestPermission(); // وأضف هذا
      await FirebaseNotificationService.instance.init();
      await FirebaseNotificationService.instance.requestPermission();

      await initializeDateFormatting('en_US');
      await initializeDateFormatting('ar_SA');

      runApp(const MyApp());
    },
    (error, stack) {
      debugPrint('🛡️ خطأ خارج النطاق المحمي: $error');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ---- Shared / core ----
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (context) => LoginCubit(getIt.get<LoginRepo>())),

        // ---- STUDENT side ----
        BlocProvider(
          create: (_) => UserCubit(UserRepository(UserRemoteDataSource(Dio()))),
        ),

        // ---- TEACHER side ----
        BlocProvider(create: (context) => getIt<UserCubitt>()),
        BlocProvider(
          create: (context) => TodaySchedualCubit(getIt.get<TeacherHomeRepo>()),
        ),
        BlocProvider(
          create: (context) => TeacherClassesCubit(getIt.get<ClassesRepo>()),
        ),
        BlocProvider(
          create: (context) => SendHomeworkCubit(getIt.get<ClassDetailsRepo>()),
        ),
        BlocProvider(
          create: (context) => SendTaskCubit(getIt.get<ClassDetailsRepo>()),
        ),
        BlocProvider(
          create: (context) =>
              FetchHomeworkCubit(getIt.get<ClassDetailsRepo>()),
        ),
        BlocProvider(
          create: (context) => FetchTaskCubit(getIt.get<ClassDetailsRepo>()),
        ),
        BlocProvider(create: (context) => getIt<DeleteTaskHomeworkCubit>()),
        BlocProvider(create: (context) => getIt<SendTeacherQuizCubit>()),
        BlocProvider(create: (context) => getIt<FetchTeacherQuizzesCubit>()),
        BlocProvider(
          create: (context) => getIt<FetchTeacherQuizDetailsCubit>(),
        ),
        BlocProvider(create: (context) => getIt<FetchQuizScoreCubit>()),
        BlocProvider(
          create: (context) => FetchStudentsCubit(getIt.get<StudentRepo>()),
        ),
        BlocProvider(
          create: (context) => WeightsCubit(getIt.get<StudentRepo>()),
        ),
        BlocProvider(create: (context) => MarksCubit(getIt.get<StudentRepo>())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return MultiBlocProvider(
                providers: [
                  // HomeCubit للطالب يعتمد على StudentUserCubit، لذلك يُنشأ هنا
                  BlocProvider(
                    create: (context) => HomeCubit(
                      HomeRepository(HomeRemoteDataSource(Dio())),
                      context.read<UserCubit>(),
                    ),
                  ),
                ],
                child: GetMaterialApp(
                  locale: locale,
                  debugShowCheckedModeBanner: false,
                  title: 'مدرسة القمة',
                  routes: {
                    '/login': (_) => const Login(),
                    '/home': (_) => const StudentMainLayout(),
                    '/teacher_home': (_) => const TeacherHome(),
                  },
                  themeMode: themeMode,
                  theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.light(
                      primary: const Color.fromARGB(255, 32, 128, 239),
                      onPrimary: kwhiteColor,
                      secondary: kseconderyColor,
                      surface: kwhiteColor,
                      onSurface: ktextColor,
                    ),
                    scaffoldBackgroundColor: kbackgroundColor,
                    splashColor: kprimeryColor.withOpacity(0.08),
                    highlightColor: const Color.fromARGB(
                      255,
                      32,
                      128,
                      239,
                    ).withOpacity(0.04),
                    appBarTheme: const AppBarTheme(
                      backgroundColor: kwhiteColor,
                      foregroundColor: ktextColor,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      centerTitle: false,
                      surfaceTintColor: Colors.transparent,
                    ),
                    cardTheme: CardThemeData(
                      color: kwhiteColor,
                      elevation: 0,
                      surfaceTintColor: Colors.transparent,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: ktextColor.withOpacity(0.08)),
                      ),
                    ),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          32,
                          128,
                          239,
                        ),
                        foregroundColor: kwhiteColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: kprimeryColor,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kprimeryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        side: BorderSide(
                          color: kprimeryColor.withOpacity(0.35),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintStyle: TextStyle(
                        color: ktextColor.withOpacity(0.38),
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: ktextColor.withOpacity(0.12),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: kprimeryColor.withOpacity(0.9),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: kLightRedColor.withOpacity(0.6),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: kLightRedColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    dialogTheme: DialogThemeData(
                      backgroundColor: kwhiteColor,
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    bottomSheetTheme: const BottomSheetThemeData(
                      backgroundColor: kwhiteColor,
                      surfaceTintColor: Colors.transparent,
                      showDragHandle: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(26),
                        ),
                      ),
                    ),
                    snackBarTheme: SnackBarThemeData(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: ktextColor,
                      contentTextStyle: const TextStyle(
                        color: kwhiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    dividerTheme: DividerThemeData(
                      color: ktextColor.withOpacity(0.08),
                      thickness: 1,
                      space: 1,
                    ),
                    datePickerTheme: DatePickerThemeData(
                      headerBackgroundColor: kprimeryColor,
                      headerForegroundColor: kwhiteColor,
                      backgroundColor: kwhiteColor,
                      dayShape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.dark,
                    colorScheme: const ColorScheme.dark(
                      primary: kprimeryColor,
                      onPrimary: kwhiteColor,
                      surface: Color(0xFF1A1C1E),
                      onSurface: Colors.white,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: kprimeryColor,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    datePickerTheme: DatePickerThemeData(
                      headerBackgroundColor: kprimeryColor,
                      headerForegroundColor: kwhiteColor,
                      backgroundColor: const Color(0xFF2C2C2C),
                      dayShape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    dialogTheme: DialogThemeData(
                      backgroundColor: const Color(0xFF2C2C2C),
                    ),
                    scaffoldBackgroundColor: const Color(0xFF121212),
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Color(0xFF1A1C1E),
                      elevation: 0,
                    ),
                    cardColor: const Color(0xFF1E1E1E),
                    dividerColor: const Color(0xFF333333),
                  ),
                  home: const Splash(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
