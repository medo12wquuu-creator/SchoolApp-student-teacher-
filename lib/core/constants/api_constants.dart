import 'package:dio/dio.dart';

class ApiConstants {
  static const String baseUrl =
      "https://diving-settle-careless.ngrok-free.dev/api";
  static const String wss = "wss://lead-sql-slim-trust.trycloudflare.com";
}

class EndPoints {
  static const String register1 = "/register";
  static const String register2 = "/complete-profile";
  static const String login = "/login";
  static const String changePassword = "/changePassword";
  static const String getUser = "/studentProfile";

  static const String saveFcmToken = "/student/fcm-token";
  static const String deleteFcmToken = "/student/fcm-token";
  static const String notifications = "/notifications";
  static const String unreadNotificationsCount = "/notifications/unread-count";
  static const String readAllNotifications = "/notifications/read-all";

  static const String attendanceAbsences = "/student/AVGattendance";

  static const String outquiz = "/student/exams";

  static const String classroom = "/classroom";

  static const String announcement = "/student/announcements";

  static const String tomorrowTasks = "/student/tomorrowTasks";
  static const String tomorrowSchedule = "/student/tomorrowLessons";
  static const String event = "/event/available";

  static const String schedule = "/student/lessonsBySection";
  static const String allTasks = "/student/tasksAndHomework";

  static const String grade = "/studentReport";

  static const String notes = "/getNotesByStudent";

  static const String chat = "/chat/conversations";
  static const String chatout = "/chat/conversations";
  static const String chatcontacts = "/chat/contacts";

  // نضيف الآن:
  static const String updateUser = "/user/me";
}

//nizar
// class ApiService {
//   final _baseURL = 'https://diving-settle-careless.ngrok-free.dev/api';
//   final Dio dio;

//   ApiService(this.dio) {
//     dio.options.connectTimeout = const Duration(seconds: 10);
//     dio.options.sendTimeout = const Duration(seconds: 10);
//     dio.options.receiveTimeout = const Duration(seconds: 10);
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

class ApiService {
  final _baseURL = 'https://diving-settle-careless.ngrok-free.dev/api';
  final Dio dio;

  String? _token;

  ApiService(this.dio) {
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.sendTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 20);
  }

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  Options get _options => Options(
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      if (_token != null && _token!.isNotEmpty)
        'Authorization': 'Bearer $_token',
    },
  );

  Future<dynamic> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    if (token != null) setToken(token);
    var response = await dio.get(
      '$_baseURL$endPoint',
      queryParameters: queryParameters,
      options: _options,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    if (token != null) setToken(token);
    var response = await dio.post(
      '$_baseURL$endPoint',
      data: body,
      options: _options,
    );
    return response.data;
  }

  Future<dynamic> delete({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    if (token != null) setToken(token);
    var response = await dio.delete(
      '$_baseURL$endPoint',
      queryParameters: queryParameters,
      options: _options,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> put({
    required String endPoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    if (token != null) setToken(token);
    var response = await dio.put(
      '$_baseURL$endPoint',
      data: body,
      options: _options,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> postMultipart({
    required String endPoint,
    required Map<String, dynamic> fields,
    String? fileField,
    String? filePath,
    String? token,
  }) async {
    if (token != null) setToken(token);

    final Map<String, dynamic> dataMap = {...fields};

    if (fileField != null && filePath != null && filePath.isNotEmpty) {
      dataMap[fileField] = await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      );
    }

    final formData = FormData.fromMap(dataMap);

    var response = await dio.post(
      '$_baseURL$endPoint',
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          if (_token != null && _token!.isNotEmpty)
            'Authorization': 'Bearer $_token',
        },
      ),
    );

    return response.data;
  }
}
