import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/presentation/view_models/note_teatcher_cubit.dart';
import 'widgets/teacher_note_card.dart';
import 'widgets/gradient_button.dart';

class TeacherNotesScreen extends StatefulWidget {
  const TeacherNotesScreen({super.key});

  @override
  State<TeacherNotesScreen> createState() => _TeacherNotesScreenState();
}

class _TeacherNotesScreenState extends State<TeacherNotesScreen> {
  bool _isPositiveSelected = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FF);
    final appBarBg = isDark
        ? const Color(0xFF1A1C1E).withOpacity(0.7)
        : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1565C0)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ملاحظات المعلمين',
          style: TextStyle(
            color: Color(0xFF1565C0),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey.shade800 : const Color(0xFFF1F3FC),
            width: 1,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [SizedBox(height: 20), TeacherNoteCard()],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: Row(
          children: [
            Expanded(
              child: GradientButton(
                text: 'سلبي',
                gradient: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                textColor: Color(0xFF475569),
                isSelected: !_isPositiveSelected,
                onTap: () {
                  setState(() => _isPositiveSelected = false);
                  context.read<NoteTeacherCubit>().showNegativeNotes();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GradientButton(
                text: 'إيجابي',
                gradient: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                textColor: Colors.white,
                isPrimary: true,
                isSelected: _isPositiveSelected,
                onTap: () {
                  setState(() => _isPositiveSelected = true);
                  context.read<NoteTeacherCubit>().showPositiveNotes();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
