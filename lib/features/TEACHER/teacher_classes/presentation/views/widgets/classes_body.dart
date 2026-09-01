
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/core/widgets/custom_error_widget.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/view_models/teacher_classes/teacher_classes_cubit.dart';
import 'package:schooly/features/TEACHER/teacher_classes/presentation/views/widgets/build_class_card.dart';
class ClassesBody extends StatefulWidget {
  const ClassesBody({super.key});

  @override
  State<ClassesBody> createState() => _ClassesBodyState();
}

class _ClassesBodyState extends State<ClassesBody> {
  final Set<int> _expandedIndices = {};

  @override
  void initState() {
    super.initState();
    context.read<TeacherClassesCubit>().fetchTeacherClasses();
  }

  List<Map<String, dynamic>> _buildAccordionItems(
    List<Map<String, List<Map<String, dynamic>>>> groups,
  ) {
    final iconColors = [
      {
        'icon': Icons.school_rounded,
        'iconBg': const Color(0xFFE8F1FF),
        'iconColor': const Color(0xFF2F80ED),
        'indicatorColor': kprimeryColor,
      },
      {
        'icon': Icons.menu_book_rounded,
        'iconBg': const Color(0xFFFEF9EE),
        'iconColor': const Color(0xFFD4A373),
        'indicatorColor': const Color(0xFFF2C94C),
      },
      {
        'icon': Icons.science_rounded,
        'iconBg': const Color(0xFFE6F9F0),
        'iconColor': kadditionalColor,
        'indicatorColor': kadditionalColor,
      },
    ];
    final sectionBg = [
      const Color(0xFFF8FAFC),
      const Color(0xFFFEF9EE),
      const Color(0xFFE8F1FF),
    ];

    return groups.asMap().entries.map((entry) {
      final palette = iconColors[entry.key % iconColors.length];
      final roomName = entry.value.keys.first;
      final sections = entry.value.values.first;

      return {
        'className': roomName,
        'subject': 'صفوف ومواد دراسية',
        'totalStudents': '${sections.length} شعبة',
        'icon': palette['icon'],
        'iconBg': palette['iconBg'],
        'iconColor': palette['iconColor'],
        'indicatorColor': palette['indicatorColor'],
        'sections': sections.asMap().entries.map((se) {
          return {
            'name': se.value['name'],
            'id': se.value['id'] ?? '0',
            'classroomId': se.value['classroomId'] ?? '0',
            'semesterId': se.value['semesterId'],
            'semesterName': se.value['semesterName'],
            'term': se.value['term'] ?? '',
            'count': se.value['count'] ?? '',
            'bg': sectionBg[se.key % sectionBg.length],
          };
        }).toList(),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: BlocBuilder<TeacherClassesCubit, TeacherClassesState>(
          builder: (context, state) {
            if (state is TeacherClassesLoading) {
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is TeacherClassesFailure) {
              return CustomErrorWidget(
                title: 'فشل تحميل بيانات الصفوف',
                errorMessage: state.errMassage,
                onRetry: () =>
                    context.read<TeacherClassesCubit>().fetchTeacherClasses(),
              );
            }
            if (state is TeacherClassesSuccess) {
              final model = state.teacherClasses;
              final groups = <String, List<Map<String, dynamic>>>{};

              void collect(dynamic section) {
                final roomName = section.classroom?.name ?? 'غير معروف';
                groups.putIfAbsent(roomName, () => []);
                groups[roomName]!.add({
                  'name': section.name ?? '---',
                  'id': section.id?.toString() ?? '0',
                  'classroomId': section.classroomId?.toString() ?? '0',
                  // 🆕 إرسال الفصل الدراسي الصحيح القادم من الباك (/teacherSections)
                  'semesterId': model.semester?.id?.toString(),
                  'semesterName': model.semester?.name,
                  'term': section.classroom?.name ?? '',
                  'count': '',
                });
              }

              model.sections?.classA?.forEach(collect);
              model.sections?.classB?.forEach(collect);

              if (groups.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Text(
                      'لا توجد شعب مخصصة لك حالياً.',
                      style: TextStyle(
                        fontSize: 15,
                        color: ktextColor.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }

              final items = _buildAccordionItems(
                groups.entries.map((e) => {e.key: e.value}).toList(),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //const ClassHeader(teacherName: 'أحمد', remainingClasses: 4),
                  const SizedBox(height: 20),
                  Text(
                    'الشعب والصفوف الدراسية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ktextColor.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return ClassAccordionItem(
                      item: item,
                      isExpanded: _expandedIndices.contains(index),
                      onToggle: () {
                        setState(() {
                          if (_expandedIndices.contains(index)) {
                            _expandedIndices.remove(index);
                          } else {
                            _expandedIndices.add(index);
                          }
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
