import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/send_homework_and_task_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/repos/class_details_repo/class_details_repo.dart';

part 'send_homework_state.dart';

class SendHomeworkCubit extends Cubit<SendHomeworkState> {
  SendHomeworkCubit(this.classDetailsRepo) : super(SendHomeworkInitial());
  final ClassDetailsRepo classDetailsRepo;

  Future<void> sendHomework({
    required String sectionId,
    required String type,
    required String title,
    required String description,
    required String deliveryDate,
    int? subjectId,
  }) async {
    emit(SendHomeworkLoading());
    try {
      var response = await classDetailsRepo.sendHomework(
        sectionId: sectionId,
        type: type,
        title: title,
        description: description,
        deliveryDate: deliveryDate,
        subjectId: subjectId,
      );

      response.fold(
        (failure) {
          emit(SendHomeworkFailure(failure.errMassage));
        },
        (result) {
          emit(SendHomeworkSuccess(sendHomework: result));
        },
      );
    } catch (e) {
      emit(SendHomeworkFailure(e.toString()));
    }
  }
}
