import 'package:equatable/equatable.dart';

import 'data.dart';

class SendQuizModel extends Equatable {
  final String? message;
  final Data? data;

  const SendQuizModel({this.message, this.data});

  factory SendQuizModel.fromJson(Map<String, dynamic> json) => SendQuizModel(
    message: json['message'] as String?,
    data: json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {'message': message, 'data': data?.toJson()};

  @override
  List<Object?> get props => [message, data];
}
