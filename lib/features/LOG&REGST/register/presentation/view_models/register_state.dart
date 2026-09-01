abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  final String code;
  RegisterSuccess(this.message, this.code);
}

class RegisterError extends RegisterState {
  final String message;
  RegisterError(this.message);
}
