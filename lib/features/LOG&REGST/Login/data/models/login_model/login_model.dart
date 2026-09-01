import 'user.dart';

class LoginModel {
  final int? statusCode;
  final String? message;
  final User? user;
  final String? token;

  const LoginModel({this.statusCode, this.message, this.user, this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
      message: json['message']?.toString(),
      token: json['token']?.toString(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'message': message,
    'token': token,
    'user': user?.toJson(),
  };
}
