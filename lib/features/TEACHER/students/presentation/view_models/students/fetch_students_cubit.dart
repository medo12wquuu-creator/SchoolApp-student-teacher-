import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:schooly/features/TEACHER/students/data/models/fetch_students_model/fetch_students_model.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_weights_model/fetch_weights_model.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_repo/student_repo.dart';

part 'fetch_students_state.dart';

class FetchStudentsCubit extends Cubit<FetchStudentsState> {
  final StudentRepo studentRepo;
  FetchStudentsCubit(this.studentRepo) : super(FetchStudentsInitial());

  Future<void> fetchStudents({
    required String sectionId,
    required String semesterId, // تعديل هنا
  }) async {
    emit(FetchStudentsLoading());
    try {
      var response = await studentRepo.fetchStudents(
        sectionId: sectionId,
        semesterId: semesterId, // تعديل هنا
      );
      response.fold(
        (failure) => emit(FetchStudentsFailure(failure.errMassage)),
        (data) => emit(
          FetchStudentsSuccess(
            students: data.students,
            weights: data.weights,
          ),
        ),
      );
    } catch (e) {
      emit(FetchStudentsFailure(e.toString()));
    }
  }
}
