import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_weights_model/fetch_weights_model.dart';
import 'package:schooly/features/TEACHER/students/data/repos/student_repo/student_repo.dart';

part 'weights_state.dart';

class WeightsCubit extends Cubit<WeightsState> {
  final StudentRepo studentRepo;
  WeightsCubit(this.studentRepo) : super(WeightsInitial());

  Future<void> fetchWeights({
    required String sectionId,
    required String semesterId, // تعديل هنا
  }) async {
    emit(WeightsLoading());
    try {
      var response = await studentRepo.fetchWheights(
        sectionId: sectionId,
        semesterId: semesterId, // تعديل هنا
      );
      response.fold(
        (failure) => emit(WeightsFailure(failure.errMassage)),
        (weights) => emit(WeightsSuccess(weights: weights)),
      );
    } catch (e) {
      emit(WeightsFailure(e.toString()));
    }
  }
}
