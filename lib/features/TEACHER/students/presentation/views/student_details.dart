import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/delete_student_report/delete_report_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/modify_student_report/modify_report_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/send_note/send_note_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/send_report/send_report_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/student_notes/student_notes_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/student_reports/student_reports_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/student_details_body.dart';

class StudentDetails extends StatelessWidget {
  final String studentName;
  final String studentPhoto;
  final String sectionName;
  final String studentId;
  final String semesterId;

  const StudentDetails({
    super.key,
    required this.studentName,
    required this.studentPhoto,
    required this.sectionName,
    required this.studentId,
    this.semesterId = '',
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<StudentNotesCubit>()),
        BlocProvider.value(value: getIt<SendNotesCubit>()),
        BlocProvider.value(value: getIt<StudentReportsCubit>()),
        BlocProvider.value(value: getIt<SendReportCubit>()),
        BlocProvider.value(value: getIt<ModifyReportCubit>()),
        BlocProvider.value(value: getIt<DeleteReportCubit>()),
      ],
      child: StudentDetailsBody(
        studentName: studentName,
        studentPhoto: studentPhoto,
        sectionName: sectionName,
        studentId: studentId,
        semesterId: semesterId,
      ),
    );
  }
}
