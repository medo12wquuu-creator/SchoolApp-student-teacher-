import 'package:schooly/features/STUDENT/student_profile/data/models/student_profile_model.dart';

abstract class StudentProfileState {}

class StudentProfileInitial extends StudentProfileState {}

class StudentProfileLoading extends StudentProfileState {}

class StudentProfileLoaded extends StudentProfileState {
  final StudentProfileModel profile;

  StudentProfileLoaded(this.profile);
}

class StudentProfileUpdating extends StudentProfileState {}

class StudentProfileUpdated extends StudentProfileState {
  final StudentProfileModel profile;

  StudentProfileUpdated(this.profile);
}

class StudentProfileError extends StudentProfileState {
  final String message;

  StudentProfileError(this.message);
}
