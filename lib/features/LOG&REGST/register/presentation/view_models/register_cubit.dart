import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/LOG&REGST/register/data/repositories/register_repository.dart';
import 'package:schooly/features/LOG&REGST/register/presentation/view_models/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository repo;

  RegisterCubit(this.repo) : super(RegisterInitial());

  // String firstName = '';
  String email = '';
  String phone = '';
  String password = '';

  // void setFirstName(String v) => firstName = v;
  void setEmail(String v) => email = v;
  void setPhone(String v) => phone = v;
  void setPassword(String v) => password = v;

  Future<void> register() async {
    emit(RegisterLoading());

    try {
      final result = await repo.register(
        // firstName: firstName,
        email: email,
        phone: phone,
        password: password,
      );

      if (result.success) {
        emit(RegisterSuccess(result.message, result.code));
      } else {
        emit(RegisterError(result.message));
      }
    } catch (e) {
      emit(RegisterError("Unexpected error: $e"));
    }
  }
}
