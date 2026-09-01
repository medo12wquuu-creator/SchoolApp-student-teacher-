import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/delete_student_report/delete_report_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/modify_student_report/modify_report_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/send_note/send_note_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/send_report/send_report_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/student_notes/student_notes_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/view_models/student_reports/student_reports_cubit.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/student_details_academic_notes.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/student_details_add_note_or_report.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/student_details_behavior_reports.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/student_details_profile_card.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/student_details_quick_actions.dart';
import 'package:schooly/features/TEACHER/students/presentation/views/widgets/student_details_section_header.dart';


class StudentDetailsBody extends StatefulWidget {
  final String studentName;
  final String studentPhoto;
  final String sectionName;
  final String studentId;
  final String semesterId;

  const StudentDetailsBody({
    super.key,
    required this.studentName,
    required this.studentPhoto,
    required this.sectionName,
    required this.studentId,
    this.semesterId = '',
  });

  @override
  State<StudentDetailsBody> createState() => _StudentDetailsBodyState();
}

class _StudentDetailsBodyState extends State<StudentDetailsBody> {
  @override
  void initState() {
    super.initState();
    context.read<StudentNotesCubit>().fetchNotes(studentId: widget.studentId);
    context.read<StudentReportsCubit>().fetchReports(
      studentId: widget.studentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<ModifyReportCubit, ModifyReportState>(
        listener: (context, state) {
          if (state is ModifyReportSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            context.read<StudentReportsCubit>().fetchReports(
              studentId: widget.studentId,
            );
          } else if (state is ModifyReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMassage),
                backgroundColor: kLightRedColor,
              ),
            );
          }
        },
        child: BlocListener<DeleteReportCubit, DeleteReportState>(
          listener: (context, state) {
            if (state is DeleteReportSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              context.read<StudentReportsCubit>().fetchReports(
                studentId: widget.studentId,
              );
            } else if (state is DeleteReportFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMassage),
                  backgroundColor: kLightRedColor,
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: kbackgroundColor,
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StudentDetailsProfileCard(
                        studentName: widget.studentName,
                        studentPhoto: widget.studentPhoto,
                        sectionName: widget.sectionName,
                      ),
                      const SizedBox(height: 24),
                      StudentDetailsQuickActions(
                        onAddNoteTap: () async {
                          final sendCubit = context.read<SendNotesCubit>();
                          final notesCubit = context.read<StudentNotesCubit>();
                          final result =
                              await showModalBottomSheet<Map<String, dynamic>>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    StudentDetailsAddNoteOrReport(
                                      type: EntryType.note,
                                      studentName: widget.studentName,
                                    ),
                              );
                          if (result != null && mounted) {
                            final type = result['isPositive'] == true
                                ? 'positive'
                                : 'negative';
                            sendCubit.sendNote(
                              studentId: widget.studentId,
                              subjectId: '1',
                              semesterId: widget.semesterId.isEmpty
                                  ? '1'
                                  : widget.semesterId,
                              type: type,
                              body: result['content'] as String,
                            );
                            notesCubit.fetchNotes(studentId: widget.studentId);
                          }
                        },
                        onAddReportTap: () async {
                          final sendCubit = context.read<SendReportCubit>();
                          final reportsCubit = context
                              .read<StudentReportsCubit>();
                          final result =
                              await showModalBottomSheet<Map<String, dynamic>>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    StudentDetailsAddNoteOrReport(
                                      type: EntryType.report,
                                      studentName: widget.studentName,
                                    ),
                              );
                          if (result != null && mounted) {
                            sendCubit.sendReport(
                              studentId: widget.studentId,
                              title: result['title'] as String,
                              description: result['content'] as String,
                              type: 'report',
                            );
                            reportsCubit.fetchReports(
                              studentId: widget.studentId,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 32),
                      const StudentDetailsSectionHeader(
                        title: 'الملاحظات الأكاديمية',
                        hasViewAll: true,
                      ),
                      const SizedBox(height: 14),
                      BlocBuilder<StudentNotesCubit, StudentNotesState>(
                        builder: (context, state) {
                          if (state is StudentNotesLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is StudentNotesFailure) {
                            return Text(state.errMassage);
                          }
                          if (state is StudentNotesSuccess) {
                            return StudentDetailsAcademicNotes(
                              notes: state.notes,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 32),
                      StudentDetailsSectionHeader(
                        title: 'التقارير السلوكية والتنبيهات',
                        isWarningTitle: true,
                      ),
                      const SizedBox(height: 14),
                      BlocBuilder<StudentReportsCubit, StudentReportsState>(
                        builder: (context, state) {
                          if (state is StudentReportsLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is StudentReportsFailure) {
                            return Text(state.errMassage);
                          }
                          if (state is StudentReportsSuccess) {
                            return StudentDetailsBehaviorReports(
                              reports: state.reports,
                              onEditReport: (updatedReport) {
                                context.read<ModifyReportCubit>().modifyReport(
                                  reportId: '${updatedReport.id}',
                                  title: updatedReport.title,
                                  description: updatedReport.description,
                                );
                              },
                              onDeleteReport: (reportToDelete) {
                                context.read<DeleteReportCubit>().deleteReport(
                                  reportId: '${reportToDelete.id}',
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kwhiteColor.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kprimeryColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward, color: ktextColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
