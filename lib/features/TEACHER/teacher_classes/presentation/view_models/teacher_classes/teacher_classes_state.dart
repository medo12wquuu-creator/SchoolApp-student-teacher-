part of 'teacher_classes_cubit.dart';

@immutable
abstract class TeacherClassesState {}

class TeacherClassesInitial extends TeacherClassesState {}

class TeacherClassesLoading extends TeacherClassesState {}

class TeacherClassesSuccess extends TeacherClassesState {
  final TeacherClassesModel teacherClasses;

  TeacherClassesSuccess({required this.teacherClasses});
}

class TeacherClassesFailure extends TeacherClassesState {
  final String errMassage;

  TeacherClassesFailure(this.errMassage);
}
