import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_repo/student_repo.dart';

part 'marks_state.dart';

class MarksCubit extends Cubit<MarksState> {
  final StudentRepo studentRepo;
  MarksCubit(this.studentRepo) : super(MarksInitial());

  Future<void> saveStudentMarks({
    required String sectionId,
    required String semesterId, // 🟢 استقبال الـ semesterId
    required String studentId,
    required List<Map<String, String>> grades,
  }) async {
    emit(MarksLoading());
    try {
      for (final grade in grades) {
        final result = await studentRepo.sendSingleMark(
          sectionId: sectionId,
          semesterId: semesterId, // 🟢 تمرير الـ semesterId
          studentId: studentId,
          weightId: grade['weight_id']!,
          score: grade['score']!,
        );
        final isFailed = result.fold((failure) {
          emit(MarksFailure(failure.errMassage));
          return true;
        }, (_) => false);
        if (isFailed) return;
      }
      emit(MarksSuccess());
    } catch (e) {
      emit(MarksFailure(e.toString()));
    }
  }
}
