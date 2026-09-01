import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/send_homework_and_task_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';

part 'send_task_state.dart';

class SendTaskCubit extends Cubit<SendTaskState> {
  SendTaskCubit(this.classDetailsRepo) : super(SendTaskInitial());

  final ClassDetailsRepo classDetailsRepo;

  Future<void> sendTask({
    required String sectionId,
    required String type,
    required String title,
    required String description,
    required String deliveryDate,
    int? subjectId,
  }) async {
    emit(SendTaskLoading());
    try {
      var response = await classDetailsRepo.sendTask(
        sectionId: sectionId,
        type: type,
        title: title,
        description: description,
        deliveryDate: deliveryDate,
        subjectId: subjectId,
      );

      response.fold(
        (failure) {
          emit(SendTaskFailure(failure.errMassage));
        },
        (result) {
          emit(SendTaskSuccess(sendTask: result));
        },
      );
    } catch (e) {
      emit(SendTaskFailure(e.toString()));
    }
  }
}
