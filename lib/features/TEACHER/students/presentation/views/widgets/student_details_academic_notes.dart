import 'package:flutter/material.dart';
import 'package:schooly/core/constants/colors.constants.dart';
import 'package:schooly/features/TEACHER/students/data/models/notes_model/notes_model.dart';

class StudentDetailsAcademicNotes extends StatelessWidget {
  final List<NotesModel> notes;

  const StudentDetailsAcademicNotes({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Text('لا توجد ملاحظات');
    }
    return Column(
      children: notes.map((note) {
        final isPositive = note.type?.toLowerCase() == 'positive';
        final iconColor = isPositive ? kadditionalColor : kLightRedColor;
        final accentBgColor = isPositive
            ? klightAdditionalColor
            : kLightRedColor.withOpacity(0.12);
        final icon = isPositive
            ? Icons.auto_awesome_rounded
            : Icons.edit_document;

        final dateStr = note.createdAt != null
            ? _formatDate(note.createdAt!)
            : '';

        final subjectName = note.subject?.name ?? '';
        final title = subjectName.isNotEmpty
            ? subjectName
            : (isPositive ? 'ملاحظة إيجابية' : 'ملاحظة سلبية');

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _buildAcademicCard(
            title: title,
            description: note.body ?? '---',
            date: dateStr,
            icon: icon,
            iconColor: iconColor,
            accentBgColor: accentBgColor,
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'اليوم';
    if (diff.inDays == 1) return 'منذ يوم';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildAcademicCard({
    required String title,
    required String description,
    required String date,
    required IconData icon,
    required Color iconColor,
    required Color accentBgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kwhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ktextColor.withOpacity(0.015),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: iconColor, width: 4)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const Spacer(),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff9098B1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ktextColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff9098B1),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
