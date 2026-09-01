// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';

// import 'package:schooly/core/constants/api_constants.dart';
// import 'package:schooly/core/errors/failure.dart';
// import 'package:schooly/features/TEACHER/Login/data/models/login_model/login_model.dart';
// import 'package:schooly/features/TEACHER/Login/data/repos/login_repo.dart';

// class LoginRepoImp implements LoginRepo {
//   final ApiService apiService;

//   LoginRepoImp(this.apiService);

//   @override
//   Future<Either<Failure, LoginModel>> sendLoginDetails({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final body = {'email': email, 'password': password};

//       var response = await apiService.post(endPoint: '/login', body: body);

//       print("======== SERVER RESPONSE ========");
//       print(response);
//       print("=================================");

//       if (response['token'] == null || response['user'] == null) {
//         String serverMessage =
//             response['message'] ?? "Account status pending admin approval.";
//         return left(ServerFailure(serverMessage));
//       }

//       final loginModel = LoginModel.fromJson(response);
//       return right(loginModel);
//     } on DioException catch (e) {
//       final responseData = e.response?.data;
//       final serverMessage =
//           (responseData is Map && responseData['message'] != null)
//           ? responseData['message'].toString()
//           : null;
//       return left(ServerFailure(serverMessage ?? 'Login failed'));
//     } catch (e) {
//       return left(ServerFailure("Parsing Error: ${e.toString()}"));
//     }
//   }
// }
