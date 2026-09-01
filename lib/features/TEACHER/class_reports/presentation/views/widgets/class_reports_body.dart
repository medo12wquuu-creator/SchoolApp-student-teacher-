import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/constants/service_locator.dart';
import 'package:schooly/features/TEACHER/class_reports/data/models/class_report_model.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/view_models/class_reports/class_reports_cubit.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/view_models/delete_report/delete_class_report_cubit.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/widgets/class_reports_empty_state_footer.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/widgets/class_reports_filter_chips.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/widgets/class_reports_header_section.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/widgets/class_reports_reports_list.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/widgets/class_reports_section_tag.dart';
import 'package:schooly/features/TEACHER/class_reports/presentation/views/widgets/class_reports_stats_cards.dart';


enum ReportStatus { pending, reviewed }

class ClassReportsBody extends StatefulWidget {
  final String sectionName;
  final String sectionId;
  final String semesterId;

  const ClassReportsBody({
    super.key,
    this.sectionName = 'الصف العاشر - شعبة أ',
    this.sectionId = '',
    this.semesterId = '',
  });

  @override
  State<ClassReportsBody> createState() => _ClassReportsBodyState();
}

class _ClassReportsBodyState extends State<ClassReportsBody> {
  int _selectedFilterIndex = 0;
  final String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<ClassReportModel> _reports = [];

  @override
  void initState() {
    super.initState();
    getIt<ClassReportsCubit>().fetchSectionReports(sectionId: widget.sectionId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ReportStatus _mapStatus(String? status) {
    switch (status) {
      case 'reviewed':
      case 'تمت المراجعة':
        return ReportStatus.reviewed;
      case 'pending':
      case 'معلقة':
      default:
        return ReportStatus.pending;
    }
  }

  List<ClassReportModel> get _filteredReports {
    return _reports.where((report) {
      bool matchesSearch =
          (report.title ?? '').contains(_searchQuery) ||
          (report.description ?? '').contains(_searchQuery) ||
          report.studentName.contains(_searchQuery);

      if (!matchesSearch) return false;

      final status = _mapStatus(report.status);
      if (_selectedFilterIndex == 0) return true;
      if (_selectedFilterIndex == 1) return status == ReportStatus.pending;
      if (_selectedFilterIndex == 2) return status == ReportStatus.reviewed;

      return true;
    }).toList();
  }

  void _showSnackbar(String title, String message, Color bgColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgColor,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ClassReportsCubit>()),
        BlocProvider.value(value: getIt<DeleteClassReportCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ClassReportsCubit, ClassReportsState>(
            listener: (context, state) {
              if (state is ClassReportsSuccess) {
                if (!identical(state.reports, _reports)) {
                  setState(() => _reports = state.reports);
                }
              } else if (state is ClassReportsFailure) {
                _showSnackbar('خطأ', state.errMassage, Colors.redAccent);
              } else if (state is ClassReportModifySuccess) {
                _showSnackbar('تم التعديل', state.message, Colors.green);
                getIt<ClassReportsCubit>().fetchSectionReports(
                  sectionId: widget.sectionId,
                );
              } else if (state is ClassReportModifyFailure) {
                _showSnackbar('خطأ', state.errMassage, Colors.redAccent);
              }
            },
          ),
          BlocListener<DeleteClassReportCubit, DeleteClassReportState>(
            listener: (context, state) {
              if (state is DeleteClassReportSuccess) {
                _showSnackbar('تم الحذف', 'تم حذف التقرير بنجاح', Colors.green);
                getIt<ClassReportsCubit>().fetchSectionReports(
                  sectionId: widget.sectionId,
                );
              } else if (state is DeleteClassReportFailure) {
                _showSnackbar(
                  'خطأ في الحذف',
                  state.errMassage,
                  Colors.redAccent,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ClassReportsCubit, ClassReportsState>(
          builder: (context, state) {
            final isLoading = state is ClassReportsLoading && _reports.isEmpty;

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: kbackgroundColor,
                body: SafeArea(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              const ClassReportsHeaderSection(),
                              const SizedBox(height: 12),
                              ClassReportsSectionTag(sectionName: widget.sectionName),
                              const SizedBox(height: 16),
                              ClassReportsStatsCards(
                                reports: _reports,
                                mapStatus: _mapStatus,
                              ),
                              const SizedBox(height: 16),
                              ClassReportsFilterChips(
                                selectedIndex: _selectedFilterIndex,
                                onSelected: (index) {
                                  setState(() {
                                    _selectedFilterIndex = index;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              ClassReportsReportsList(
                                reports: _reports,
                                filteredReports: _filteredReports,
                                mapStatus: _mapStatus,
                              ),
                              const SizedBox(height: 24),
                              const ClassReportsEmptyStateFooter(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}