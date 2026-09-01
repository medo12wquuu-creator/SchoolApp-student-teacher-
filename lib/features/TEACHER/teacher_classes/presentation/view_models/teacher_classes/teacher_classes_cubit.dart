import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/teacher_classes_model/teacher_classes_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/classes_repo/classes_repo.dart';

part 'teacher_classes_state.dart';

class TeacherClassesCubit extends Cubit<TeacherClassesState> {
  TeacherClassesCubit(this.teacherHomeRepo) : super(TeacherClassesInitial());

  final ClassesRepo teacherHomeRepo;

  Future<void> fetchTeacherClasses() async {
    emit(TeacherClassesLoading());
    try {
      var response = await teacherHomeRepo.fetchTeacherClasses();

      response.fold(
        (failure) {
          emit(TeacherClassesFailure(failure.errMassage));
        },
        (teacherClasses) {
          emit(TeacherClassesSuccess(teacherClasses: teacherClasses));
        },
      );
    } catch (e) {
      emit(TeacherClassesFailure(e.toString()));
    }
  }
}
