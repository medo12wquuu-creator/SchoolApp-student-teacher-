import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/fetch_homework_and_task_model/fetch_homework_and_task_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';

part 'fetch_task_state.dart';

class FetchTaskCubit extends Cubit<FetchTaskState> {
  FetchTaskCubit(this.classDetailsRepo) : super(FetchTaskInitial());
  final ClassDetailsRepo classDetailsRepo;

  Future<void> fetchTasks(String sectionId) async {
    emit(FetchTaskLoading());
    try {
      var response = await classDetailsRepo.fetchTasks(sectionId);

      response.fold(
        (failure) {
          emit(FetchTaskFailure(failure.errMassage));
        },
        (items) {
          emit(FetchTaskSucces(fetchTask: items));
        },
      );
    } catch (e) {
      emit(FetchTaskFailure(e.toString()));
    }
  }
}
