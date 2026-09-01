import 'package:equatable/equatable.dart';

class SendClassReportModel extends Equatable {
  final String? message;

  const SendClassReportModel({this.message});

  factory SendClassReportModel.fromJson(Map<String, dynamic> json) {
    return SendClassReportModel(message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
