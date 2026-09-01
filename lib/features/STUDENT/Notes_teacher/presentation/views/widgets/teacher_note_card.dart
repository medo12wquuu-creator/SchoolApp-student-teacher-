import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/presentation/view_models/note_teatcher_cubit.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/presentation/view_models/note_teatcher_state.dart';
import 'package:schooly/features/STUDENT/Notes_teacher/presentation/views/widgets/teacher_note_date.dart';

class TeacherNoteCard extends StatelessWidget {
  const TeacherNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteTeacherCubit, NoteTeacherState>(
      builder: (context, state) {
        if (state is NoteTeacherLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: CircularProgressIndicator(color: Color(0xFF1E88E5)),
            ),
          );
        }

        if (state is NoteTeacherError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    // state.message,
                    'فشل في تحميل الملاحظات. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is NoteTeacherLoaded) {
          final notes = state.displayedNotes;

          if (notes.isEmpty) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد ملاحظات ${state.showPositive ? "إيجابية" : "سلبية"} بعد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: notes.map((note) {
              final ImageProvider? imageProvider;
              if (note.teacherPhotoFile != null) {
                imageProvider = FileImage(note.teacherPhotoFile!);
              } else if (note.teacherPhotoUrl != null &&
                  note.teacherPhotoUrl!.isNotEmpty) {
                imageProvider = NetworkImage(note.teacherPhotoUrl!);
              } else {
                imageProvider = null;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _NoteCard(note: note, imageProvider: imageProvider),
              );
            }).toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  final dynamic note;
  final ImageProvider? imageProvider;

  const _NoteCard({required this.note, this.imageProvider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final nameColor = isDark ? Colors.white : const Color(0xFF1A1C1E);
    final subjectColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final bodyColor = isDark ? Colors.grey.shade300 : const Color(0xFF44474E);

    return Card(
      elevation: 8,
      shadowColor: const Color(0xFF1E88E5).withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Text(
                          note.teacherFirstName.isNotEmpty
                              ? note.teacherFirstName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1C1E),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.teacherFullName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: nameColor,
                        ),
                      ),
                      Text(
                        note.subjectName,
                        style: TextStyle(
                          fontSize: 14,
                          color: subjectColor,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF90CAF9).withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '"${note.body}"',
              style: TextStyle(
                fontSize: 16,
                color: bodyColor,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            TeacherNoteDate(date: note.createdAt),
          ],
        ),
      ),
    );
  }
}
