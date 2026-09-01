import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/fetch_homework_and_task_model/fetch_homework_and_task_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';

part 'fetch_homework_state.dart';

class FetchHomeworkCubit extends Cubit<FetchHomeworkState> {
  FetchHomeworkCubit(this.classDetailsRepo) : super(FetchHomeworkInitial());
  final ClassDetailsRepo classDetailsRepo;

  Future<void> fetchHomework(String sectionId) async {
    emit(FetchHomeworkLoading());
    try {
      var response = await classDetailsRepo.fetchHomework(sectionId);

      response.fold(
        (failure) {
          emit(FetchHomeworkFailure(failure.errMassage));
        },
        (items) {
          emit(FetchHomeworkSucces(fetchHomework: items));
        },
      );
    } catch (e) {
      emit(FetchHomeworkFailure(e.toString()));
    }
  }
}
