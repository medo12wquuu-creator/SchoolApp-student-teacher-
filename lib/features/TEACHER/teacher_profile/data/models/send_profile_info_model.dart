import 'package:equatable/equatable.dart';

class SendProfileInfoModel extends Equatable {
  final String? message;

  const SendProfileInfoModel({this.message});

  factory SendProfileInfoModel.fromJson(Map<String, dynamic> json) {
    return SendProfileInfoModel(message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
