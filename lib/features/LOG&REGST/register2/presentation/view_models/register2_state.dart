import '../../data/models/classroom_model.dart';

abstract class Register2State {}

class Register2Initial extends Register2State {}

class Register2Loading extends Register2State {}

class Register2ClassesLoading extends Register2State {}

class Register2ClassesLoaded extends Register2State {
  final List<ClassroomModel> classes;

  Register2ClassesLoaded(this.classes);
}

class Register2Success extends Register2State {
  final String message;
  Register2Success(this.message);
}

class Register2Error extends Register2State {
  final String message;
  Register2Error(this.message);
}
