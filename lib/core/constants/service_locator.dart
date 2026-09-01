// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:schooly/core/constants/api_constants.dart';
// import 'package:schooly/core/services/chat_socket_service.dart';
// import 'package:schooly/features/LOG&REGST/Login/data/repos/login_repo.dart';
// import 'package:schooly/features/LOG&REGST/Login/data/repos/login_repo_imp.dart';
// import 'package:schooly/features/TEACHER/class_reports/data/repo/class_reports_repo.dart';
// import 'package:schooly/features/TEACHER/class_reports/data/repo/class_reports_repo_imp.dart';
// import 'package:schooly/features/TEACHER/class_reports/presentation/view_models/class_reports/class_reports_cubit.dart';
// import 'package:schooly/features/TEACHER/class_reports/presentation/view_models/delete_report/delete_class_report_cubit.dart';
// import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_details_repo.dart';
// import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_reoo_imp.dart';
// import 'package:schooly/features/TEACHER/students/data/repos/student_repo/student_repo.dart';
// import 'package:schooly/features/TEACHER/students/data/repos/student_repo/student_repo_imp.dart';
// import 'package:schooly/features/TEACHER/students/presentation/view_models/delete_student_report/delete_report_cubit.dart';
// import 'package:schooly/features/TEACHER/students/presentation/view_models/marks/marks_cubit.dart';
// import 'package:schooly/features/TEACHER/students/presentation/view_models/modify_student_report/modify_report_cubit.dart';
// import 'package:schooly/features/TEACHER/students/presentation/view_models/send_note/send_note_cubit.dart';
// import 'package:schooly/features/TEACHER/students/presentation/view_models/send_report/send_report_cubit.dart';
// import 'package:schooly/features/TEACHER/students/presentation/view_models/student_notes/student_notes_cubit.dart';
// import 'package:schooly/features/TEACHER/students/presentation/view_models/student_reports/student_reports_cubit.dart';
// import 'package:schooly/features/TEACHER/students/presentation/view_models/students/fetch_students_cubit.dart';
// import 'package:schooly/features/TEACHER/students/presentation/view_models/weights/weights_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_chat/data/repos/contacts_repo/contacts_repo.dart';
// import 'package:schooly/features/TEACHER/teacher_chat/data/repos/contacts_repo/contacts_repo_imp.dart';
// import 'package:schooly/features/TEACHER/teacher_chat/presentation/view_models/contacts/contacts_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_chat/presentation/view_models/conversations/conversations_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_chat_room/data/repos/chat_repo/chat_repo.dart';
// import 'package:schooly/features/TEACHER/teacher_chat_room/data/repos/chat_repo/chat_repo_imp.dart';
// import 'package:schooly/features/TEACHER/teacher_chat_room/presentation/view_models/chat/chat_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';
// import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo_imp.dart';
// import 'package:schooly/features/TEACHER/teacher_classes/data/repos/classes_repo/classes_repo.dart';
// import 'package:schooly/features/TEACHER/teacher_classes/data/repos/classes_repo/classes_repo_imp.dart';
// import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_delete_task_homework/delete_task_homework_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_fetch_Attendance/fetch_atendance_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_send_report/send_class_report_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_take_Attendance/cubit/take_atendance_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_home/data/repos/teacher_home_repo.dart';
// import 'package:schooly/features/TEACHER/teacher_home/data/repos/teacher_home_repo_im.dart';
// import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/fetch_teacher_profile_info/fetch_profile_info_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/teacher_reports/teacher_reports_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_profile/data/repo/teacher_profile_repo.dart';
// import 'package:schooly/features/TEACHER/teacher_profile/data/repo/teacher_profile_repo_imp.dart';
// import 'package:schooly/features/TEACHER/teacher_profile/presentation/view_models/edit_password/send_new_password_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_profile/presentation/view_models/send_profile_info/send_teacher_profile_info_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/quiz_store.dart';
// import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/teacher_quiz_repo.dart';
// import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/teacher_quiz_repo_imp.dart';
// import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_quiz_score/fetch_quiz_score_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_teacher_quiz_details/fetch_teacher_quiz_details_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_teacher_quizzes/fetch_teacher_quizzes_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/send_teacher_quiz/send_teacher_quiz_cubit.dart';
// import 'package:schooly/features/TEACHER/teacher_weak_schedual/data/repo/weak_schedual_repo.dart';
// import 'package:schooly/features/TEACHER/teacher_weak_schedual/data/repo/weak_schedual_repo_imp.dart';
// import 'package:schooly/features/TEACHER/teacher_weak_schedual/presentation/view_models/weak_schedual/weak_schedual_cubit.dart';
// import 'package:schooly/features/TEACHER/user/data/datasource/user_remote_data_source.dart';
// import 'package:schooly/features/TEACHER/user/data/repositories/user_repository.dart';
// import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';

// final getIt = GetIt.instance;

// void setup() {
//   // ⏱️ مهلات زمنية قصيرة حتى لو الباك/النفق مو شغال لا يعلق التطبيق
//   final dio = Dio(
//     BaseOptions(
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 20),
//       sendTimeout: const Duration(seconds: 20),
//     ),
//   );
//   getIt.registerSingleton<ApiService>(ApiService(dio));
//   getIt.registerSingleton<LoginRepo>(LoginRepoImp(getIt.get<ApiService>()));
//   getIt.registerSingleton<UserRemoteDataSource>(
//     UserRemoteDataSource(getIt.get<ApiService>()),
//   );
//   getIt.registerSingleton<UserRepository>(
//     UserRepository(getIt.get<UserRemoteDataSource>()),
//   );
//   getIt.registerSingleton<UserCubitt>(UserCubitt(getIt.get<UserRepository>()));
//   getIt.registerSingleton<TeacherHomeRepo>(
//     TeacherHomeRepoIm(getIt.get<ApiService>()),
//   );
//   getIt.registerSingleton<ClassesRepo>(ClassesRepoImp(getIt.get<ApiService>()));
//   getIt.registerSingleton<ClassDetailsRepo>(
//     ClassDetailsRepoImp(getIt.get<ApiService>()),
//   );
//   getIt.registerSingleton<StudentRepo>(StudentRepoImp(getIt.get<ApiService>()));
//   getIt.registerSingleton<StudentDetailsRepo>(
//     StudentDetailsRepoImpl(getIt.get<ApiService>()),
//   );
//   getIt.registerSingleton<FetchStudentsCubit>(
//     FetchStudentsCubit(getIt.get<StudentRepo>()),
//   );
//   getIt.registerSingleton<WeightsCubit>(WeightsCubit(getIt.get<StudentRepo>()));
//   getIt.registerSingleton<MarksCubit>(MarksCubit(getIt.get<StudentRepo>()));
//   getIt.registerSingleton<StudentNotesCubit>(
//     StudentNotesCubit(getIt.get<StudentDetailsRepo>()),
//   );
//   getIt.registerSingleton<SendNotesCubit>(
//     SendNotesCubit(getIt.get<StudentDetailsRepo>()),
//   );
//   getIt.registerSingleton<StudentReportsCubit>(
//     StudentReportsCubit(getIt.get<StudentDetailsRepo>()),
//   );
//   getIt.registerSingleton<SendReportCubit>(
//     SendReportCubit(getIt.get<StudentDetailsRepo>()),
//   );
//   getIt.registerSingleton<ModifyReportCubit>(
//     ModifyReportCubit(getIt.get<StudentDetailsRepo>()),
//   );
//   getIt.registerSingleton<DeleteReportCubit>(
//     DeleteReportCubit(getIt.get<StudentDetailsRepo>()),
//   );
//   getIt.registerSingleton<FetchAtendanceCubit>(
//     FetchAtendanceCubit(getIt.get<ClassDetailsRepo>()),
//   );
//   getIt.registerSingleton<TakeAtendanceCubit>(
//     TakeAtendanceCubit(getIt.get<ClassDetailsRepo>()),
//   );
//   getIt.registerSingleton<SendClassReportCubit>(
//     SendClassReportCubit(getIt.get<ClassDetailsRepo>()),
//   );
//   getIt.registerSingleton<DeleteTaskHomeworkCubit>(
//     DeleteTaskHomeworkCubit(getIt.get<ClassDetailsRepo>()),
//   );
//   getIt.registerSingleton<WeakSchedualRepo>(
//     WeakSchedualRepoImp(getIt.get<ApiService>()),
//   );
//   getIt.registerSingleton<WeakSchedualCubit>(
//     WeakSchedualCubit(getIt.get<WeakSchedualRepo>()),
//   );
//   getIt.registerSingleton<FetchProfileInfoCubit>(
//     FetchProfileInfoCubit(getIt.get<TeacherHomeRepo>()),
//   );
//   getIt.registerSingleton<TeacherProfileRepo>(
//     TeacherProfileRepoImp(getIt.get<ApiService>()),
//   );
//   getIt.registerSingleton<SendTeacherProfileInfoCubit>(
//     SendTeacherProfileInfoCubit(getIt.get<TeacherProfileRepo>()),
//   );
//   getIt.registerSingleton<SendNewPasswordCubit>(
//     SendNewPasswordCubit(getIt.get<TeacherProfileRepo>()),
//   );
//   getIt.registerSingleton<ClassReportsRepo>(
//     ClassReportsRepoImp(getIt.get<ApiService>()),
//   );
//   getIt.registerSingleton<ClassReportsCubit>(
//     ClassReportsCubit(getIt.get<ClassReportsRepo>()),
//   );
//   getIt.registerSingleton<DeleteClassReportCubit>(
//     DeleteClassReportCubit(getIt.get<ClassReportsRepo>()),
//   );

//   // 💬 إعدادات المحادثات الموحدة
//   getIt.registerLazySingleton<ChatSocketService>(() => ChatSocketService());
//   getIt.registerSingleton<ChatRepo>(ChatRepoImp(getIt.get<ApiService>()));
//   getIt.registerSingleton<ContactsRepo>(
//     ContactsRepoImp(getIt.get<ApiService>()),
//   );

//   // ملاحظة: registerLazySingleton وليس registerFactory —
//   // الشاشة تطلب نفس النسخة في initState و build، ولو كانت factory
//   // لتلقّى الـ BlocBuilder نسخة فارغة جديدة كل مرّة فلا تظهر الشعب.
//   getIt.registerLazySingleton<ConversationsCubit>(
//     () => ConversationsCubit(
//       repository: getIt.get<ChatRepo>(),
//       socket: getIt.get<ChatSocketService>(),
//       myId: getIt.get<UserCubitt>().currentUser?.id ?? 0,
//     ),
//   );

//   getIt.registerFactory<ChatCubit>(
//     () => ChatCubit(
//       repo: getIt.get<ChatRepo>(),
//       socket: getIt.get<ChatSocketService>(),
//       myId: getIt.get<UserCubitt>().currentUser?.id ?? 0,
//     ),
//   );

//   getIt.registerLazySingleton<ContactsCubit>(
//     () => ContactsCubit(getIt.get<ContactsRepo>()),
//   );

//   // 📝 مخزن الكويزات المؤقت (بدون باك إند حالياً)
//   getIt.registerLazySingleton<QuizStore>(() => QuizStore());

//   // 🚀 إرسال الكويزات للباك إيند
//   getIt.registerLazySingleton<TeacherQuizzesDetailsRepo>(
//     () => TeacherQuizzesDetailsRepoImp(getIt.get<ApiService>()),
//   );
//   getIt.registerLazySingleton<SendTeacherQuizCubit>(
//     () => SendTeacherQuizCubit(getIt.get<TeacherQuizzesDetailsRepo>()),
//   );
//   getIt.registerLazySingleton<FetchTeacherQuizzesCubit>(
//     () => FetchTeacherQuizzesCubit(getIt.get<TeacherQuizzesDetailsRepo>()),
//   );
//   getIt.registerLazySingleton<FetchTeacherQuizDetailsCubit>(
//     () => FetchTeacherQuizDetailsCubit(getIt.get<TeacherQuizzesDetailsRepo>()),
//   );
//   getIt.registerLazySingleton<FetchQuizScoreCubit>(
//     () => FetchQuizScoreCubit(getIt.get<TeacherQuizzesDetailsRepo>()),
//   );
//   getIt.registerLazySingleton<TeacherReportsCubit>(
//     () => TeacherReportsCubit(
//       quizzesRepo: getIt.get<TeacherQuizzesDetailsRepo>(),
//       classesRepo: getIt.get<ClassesRepo>(),
//       homeRepo: getIt.get<TeacherHomeRepo>(),
//       classDetailsRepo: getIt.get<ClassDetailsRepo>(),
//       classReportsRepo: getIt.get<ClassReportsRepo>(),
//     ),
//   );
// }
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/services/chat_socket_service.dart';
import 'package:schooly/features/LOG&REGST/Login/data/repos/login_repo.dart';
import 'package:schooly/features/LOG&REGST/Login/data/repos/login_repo_imp.dart';
import 'package:schooly/features/TEACHER/class_reports/data/repo/class_reports_repo.dart';
import 'package:schooly/features/TEACHER/class_reports/data/repo/class_reports_repo_imp.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/view_models/class_reports/class_reports_cubit.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/view_models/delete_report/delete_class_report_cubit.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_details_repo.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_details_repo/student_reoo_imp.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_repo/student_repo.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_repo/student_repo_imp.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/delete_student_report/delete_report_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/marks/marks_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/modify_student_report/modify_report_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/send_note/send_note_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/send_report/send_report_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/student_notes/student_notes_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/student_reports/student_reports_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/students/fetch_students_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/weights/weights_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/repos/contacts_repo/contacts_repo.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/repos/contacts_repo/contacts_repo_imp.dart';
import 'package:schooly/features/TEACHER/teacher_chat/presentation/view_models/contacts/contacts_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_chat/presentation/view_models/conversations/conversations_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/data/repos/chat_repo/chat_repo.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/data/repos/chat_repo/chat_repo_imp.dart';
import 'package:schooly/features/TEACHER/teacher_chat_room/presentation/view_models/chat/chat_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo_imp.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/classes_repo/classes_repo.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/classes_repo/classes_repo_imp.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_delete_task_homework/delete_task_homework_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_fetch_Attendance/fetch_atendance_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_send_report/send_class_report_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/class_details_take_Attendance/cubit/take_atendance_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/repos/teacher_home_repo.dart';
import 'package:schooly/features/TEACHER/teacher_home/data/repos/teacher_home_repo_im.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/fetch_teacher_profile_info/fetch_profile_info_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_home/presentation/view_models/teacher_reports/teacher_reports_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_profile/data/repo/teacher_profile_repo.dart';
import 'package:schooly/features/TEACHER/teacher_profile/data/repo/teacher_profile_repo_imp.dart';
import 'package:schooly/features/TEACHER/teacher_profile/presentation/view_models/edit_password/send_new_password_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_profile/presentation/view_models/send_profile_info/send_teacher_profile_info_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/quiz_store.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/teacher_quiz_repo.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/data/repos/teacher_quiz_repo_imp.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_quiz_score/fetch_quiz_score_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_teacher_quiz_details/fetch_teacher_quiz_details_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/fetch_teacher_quizzes/fetch_teacher_quizzes_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_quiz/presentation/view_models/send_teacher_quiz/send_teacher_quiz_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/data/repo/weak_schedual_repo.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/data/repo/weak_schedual_repo_imp.dart';
import 'package:schooly/features/TEACHER/teacher_weak_schedual/presentation/view_models/weak_schedual/weak_schedual_cubit.dart';
import 'package:schooly/features/TEACHER/user/data/datasource/user_remote_data_source.dart';
import 'package:schooly/features/TEACHER/user/data/repositories/user_repository.dart';
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  // ⏱️ مهلات زمنية قصيرة حتى لو الباك/النفق مو شغال لا يعلق التطبيق
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ),
  );
  getIt.registerSingleton<ApiService>(ApiService(dio));
  getIt.registerSingleton<LoginRepo>(LoginRepoImp(getIt.get<ApiService>()));
  getIt.registerSingleton<UserRemoteDataSource>(
    UserRemoteDataSource(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<UserRepository>(
    UserRepository(getIt.get<UserRemoteDataSource>()),
  );
  getIt.registerSingleton<UserCubitt>(UserCubitt(getIt.get<UserRepository>()));
  getIt.registerSingleton<TeacherHomeRepo>(
    TeacherHomeRepoIm(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<ClassesRepo>(ClassesRepoImp(getIt.get<ApiService>()));
  getIt.registerSingleton<ClassDetailsRepo>(
    ClassDetailsRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<StudentRepo>(StudentRepoImp(getIt.get<ApiService>()));
  getIt.registerSingleton<StudentDetailsRepo>(
    StudentDetailsRepoImpl(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<FetchStudentsCubit>(
    FetchStudentsCubit(getIt.get<StudentRepo>()),
  );
  getIt.registerSingleton<WeightsCubit>(WeightsCubit(getIt.get<StudentRepo>()));
  getIt.registerSingleton<MarksCubit>(MarksCubit(getIt.get<StudentRepo>()));
  getIt.registerSingleton<StudentNotesCubit>(
    StudentNotesCubit(getIt.get<StudentDetailsRepo>()),
  );
  getIt.registerSingleton<SendNotesCubit>(
    SendNotesCubit(getIt.get<StudentDetailsRepo>()),
  );
  getIt.registerSingleton<StudentReportsCubit>(
    StudentReportsCubit(getIt.get<StudentDetailsRepo>()),
  );
  getIt.registerSingleton<SendReportCubit>(
    SendReportCubit(getIt.get<StudentDetailsRepo>()),
  );
  getIt.registerSingleton<ModifyReportCubit>(
    ModifyReportCubit(getIt.get<StudentDetailsRepo>()),
  );
  getIt.registerSingleton<DeleteReportCubit>(
    DeleteReportCubit(getIt.get<StudentDetailsRepo>()),
  );
  getIt.registerSingleton<FetchAtendanceCubit>(
    FetchAtendanceCubit(getIt.get<ClassDetailsRepo>()),
  );
  getIt.registerSingleton<TakeAtendanceCubit>(
    TakeAtendanceCubit(getIt.get<ClassDetailsRepo>()),
  );
  getIt.registerSingleton<SendClassReportCubit>(
    SendClassReportCubit(getIt.get<ClassDetailsRepo>()),
  );
  getIt.registerSingleton<DeleteTaskHomeworkCubit>(
    DeleteTaskHomeworkCubit(getIt.get<ClassDetailsRepo>()),
  );
  getIt.registerSingleton<WeakSchedualRepo>(
    WeakSchedualRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<WeakSchedualCubit>(
    WeakSchedualCubit(getIt.get<WeakSchedualRepo>()),
  );
  getIt.registerSingleton<FetchProfileInfoCubit>(
    FetchProfileInfoCubit(getIt.get<TeacherHomeRepo>()),
  );
  getIt.registerSingleton<TeacherProfileRepo>(
    TeacherProfileRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<SendTeacherProfileInfoCubit>(
    SendTeacherProfileInfoCubit(getIt.get<TeacherProfileRepo>()),
  );
  getIt.registerSingleton<SendNewPasswordCubit>(
    SendNewPasswordCubit(getIt.get<TeacherProfileRepo>()),
  );
  getIt.registerSingleton<ClassReportsRepo>(
    ClassReportsRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<ClassReportsCubit>(
    ClassReportsCubit(getIt.get<ClassReportsRepo>()),
  );
  getIt.registerSingleton<DeleteClassReportCubit>(
    DeleteClassReportCubit(getIt.get<ClassReportsRepo>()),
  );

  // 💬 إعدادات المحادثات الموحدة
  getIt.registerLazySingleton<ChatSocketService>(() => ChatSocketService());
  getIt.registerSingleton<ChatRepo>(ChatRepoImp(getIt.get<ApiService>()));
  getIt.registerSingleton<ContactsRepo>(
    ContactsRepoImp(getIt.get<ApiService>()),
  );

  // ملاحظة: registerLazySingleton وليس registerFactory —
  // الشاشة تطلب نفس النسخة في initState و build، ولو كانت factory
  // لتلقّى الـ BlocBuilder نسخة فارغة جديدة كل مرّة فلا تظهر الشعب.
  getIt.registerLazySingleton<ConversationsCubit>(
    () => ConversationsCubit(
      repository: getIt.get<ChatRepo>(),
      socket: getIt.get<ChatSocketService>(),
      myId: getIt.get<UserCubitt>().currentUser?.id ?? 0,
    ),
  );

  getIt.registerFactory<ChatCubit>(
    () => ChatCubit(
      repo: getIt.get<ChatRepo>(),
      socket: getIt.get<ChatSocketService>(),
      myId: getIt.get<UserCubitt>().currentUser?.id ?? 0,
    ),
  );

  getIt.registerLazySingleton<ContactsCubit>(
    () => ContactsCubit(getIt.get<ContactsRepo>()),
  );

  // 📝 مخزن الكويزات المؤقت (بدون باك إند حالياً)
  getIt.registerLazySingleton<QuizStore>(() => QuizStore());

  // 🚀 إرسال الكويزات للباك إيند
  getIt.registerLazySingleton<TeacherQuizzesDetailsRepo>(
    () => TeacherQuizzesDetailsRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerLazySingleton<SendTeacherQuizCubit>(
    () => SendTeacherQuizCubit(getIt.get<TeacherQuizzesDetailsRepo>()),
  );
  getIt.registerLazySingleton<FetchTeacherQuizzesCubit>(
    () => FetchTeacherQuizzesCubit(getIt.get<TeacherQuizzesDetailsRepo>()),
  );
  getIt.registerLazySingleton<FetchTeacherQuizDetailsCubit>(
    () => FetchTeacherQuizDetailsCubit(getIt.get<TeacherQuizzesDetailsRepo>()),
  );
  getIt.registerLazySingleton<FetchQuizScoreCubit>(
    () => FetchQuizScoreCubit(getIt.get<TeacherQuizzesDetailsRepo>()),
  );
  getIt.registerLazySingleton<TeacherReportsCubit>(
    () => TeacherReportsCubit(
      quizzesRepo: getIt.get<TeacherQuizzesDetailsRepo>(),
      classesRepo: getIt.get<ClassesRepo>(),
      homeRepo: getIt.get<TeacherHomeRepo>(),
      classDetailsRepo: getIt.get<ClassDetailsRepo>(),
      classReportsRepo: getIt.get<ClassReportsRepo>(),
    ),
  );
}
