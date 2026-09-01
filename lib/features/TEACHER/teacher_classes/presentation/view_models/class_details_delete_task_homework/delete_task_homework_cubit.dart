import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';

part 'delete_task_homework_state.dart';

class DeleteTaskHomeworkCubit extends Cubit<DeleteTaskHomeworkState> {
  DeleteTaskHomeworkCubit(this.classDetailsRepo)
    : super(DeleteTaskHomeworkInitial());
  final ClassDetailsRepo classDetailsRepo;

  Future<void> deleteTaskHomework(int id) async {
    emit(DeleteTaskHomeworkLoading());
    try {
      var response = await classDetailsRepo.deleteTaskHomework(id);
      response.fold(
        (failure) => emit(DeleteTaskHomeworkFailure(failure.errMassage)),
        (result) => emit(DeleteTaskHomeworkSuccess()),
      );
    } catch (e) {
      emit(DeleteTaskHomeworkFailure(e.toString()));
    }
  }
}