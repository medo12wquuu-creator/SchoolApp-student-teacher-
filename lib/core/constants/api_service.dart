// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';

// class ApiService {
//   final _baseURL = 'https://diving-settle-careless.ngrok-free.dev/api';
//   final Dio dio;

//   ApiService(this.dio) {
//     // 🧠 تسجيل تفاصيل أي طلب فاشل في الـ debug (endpoint + status + response كاملة)
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onError: (error, handler) {
//           final request = error.requestOptions;
//           debugPrint('🔴 [API Error] ${request.method} ${request.uri}');
//           debugPrint('   Status: ${error.response?.statusCode}');
//           debugPrint('   Type: ${error.type}');
//           debugPrint('   Response: ${error.response?.data}');
//           handler.next(error);
//         },
//       ),
//     );
//   }

//   String? _token;

//   /// تعيين توكن الدخول ليتم إرساله كـ Authorization Bearer مع كل طلب
//   void setToken(String token) => _token = token;

//   void clearToken() => _token = null;

//   Options get _options => Options(
//     headers: {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//       'ngrok-skip-browser-warning': 'true',
//       if (_token != null) 'Authorization': 'Bearer $_token',
//     },
//   );

//   Future<Map<String, dynamic>> post({
//     required String endPoint,
//     required Map<String, dynamic> body,
//     Map<String, dynamic>? queryParameters,
//     String? token,
//   }) async {
//     if (token != null) setToken(token);
//     var response = await dio.post(
//       '$_baseURL$endPoint',
//       data: body,
//       queryParameters: queryParameters,
//       options: _options,
//     );
//     return response.data;
//   }

//   Future<dynamic> get({
//     required String endPoint,
//     Map<String, dynamic>? queryParameters,
//     String? token,
//   }) async {
//     if (token != null) setToken(token);
//     var response = await dio.get(
//       '$_baseURL$endPoint',
//       queryParameters: queryParameters,
//       options: _options,
//     );
//     return response.data;
//   }

//   // 🗑️ طريقة DELETE لدعم حذف الموارد من الخادم
//   Future<dynamic> delete({
//     required String endPoint,
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? body,
//     String? token,
//   }) async {
//     if (token != null) setToken(token);
//     var response = await dio.delete(
//       '$_baseURL$endPoint',
//       queryParameters: queryParameters,
//       data: body,
//       options: _options,
//     );
//     return response.data;
//   }

//   Future<Map<String, dynamic>> put({
//     required String endPoint,
//     required Map<String, dynamic> body,
//     Map<String, dynamic>? queryParameters,
//     String? token,
//   }) async {
//     if (token != null) setToken(token);
//     var response = await dio.put(
//       '$_baseURL$endPoint',
//       data: body,
//       queryParameters: queryParameters,
//       options: _options,
//     );
//     return response.data;
//   }

//   // 🟢 تعديل postMultipart لتمرير الملف اختيارياً بدعم كامل لـ Multipart/Form-Data
//   Future<Map<String, dynamic>> postMultipart({
//     required String endPoint,
//     required Map<String, dynamic> fields,
//     String? fileField,
//     String? filePath,
//   }) async {
//     final Map<String, dynamic> dataMap = {...fields};

//     if (fileField != null && filePath != null && filePath.isNotEmpty) {
//       dataMap[fileField] = await MultipartFile.fromFile(
//         filePath,
//         filename: filePath.split('/').last,
//       );
//     }

//     final formData = FormData.fromMap(dataMap);

//     var response = await dio.post(
//       '$_baseURL$endPoint',
//       data: formData,
//       options: Options(
//         headers: {
//           'Accept': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//           if (_token != null) 'Authorization': 'Bearer $_token',
//         },
//       ),
//     );

//     return response.data;
//   }
// }
