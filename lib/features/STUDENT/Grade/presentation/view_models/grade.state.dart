import 'package:schooly/features/STUDENT/Grade/data/models/grade_model.dart';

abstract class GradeState {}

class GradeInitial extends GradeState {}

class GradeLoading extends GradeState {}

class GradeLoaded extends GradeState {
  final GradePageModel data;
  final int selectedSemesterIndex;

  GradeLoaded(this.data, {this.selectedSemesterIndex = 0});
}

class GradeError extends GradeState {
  final String message;

  GradeError(this.message);
}
