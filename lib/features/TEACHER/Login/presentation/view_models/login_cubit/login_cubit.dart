// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:schooly/features/TEACHER/Login/data/models/login_model/login_model.dart';
// import 'package:schooly/features/TEACHER/Login/data/repos/login_repo.dart';

// part 'login_state.dart';

// class LoginCubit extends Cubit<LoginState> {
//   LoginCubit(this.loginRepo) : super(LoginInitial());

//   final LoginRepo loginRepo;
//   String email = '';
//   String password = '';

//   void setEmail(String v) => email = v;
//   void setPassword(String v) => password = v;
//   Future<void> sendLoginDetails() async {
//     emit(LoginLoading());
//     try {
//       final result = await loginRepo.sendLoginDetails(
//         email: email,
//         password: password,
//       );

//       result.fold(
//         (failure) {
//           emit(LoginFailure(failure.errMassage));
//         },
//         (loginModel) {
//           emit(LoginSuccess(loginModel));
//         },
//       );
//     } catch (e) {
//       emit(LoginFailure('Unexpected error : $e'));
//     }
//   }
// }
