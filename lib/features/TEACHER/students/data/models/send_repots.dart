import 'package:equatable/equatable.dart';

class SendRepots extends Equatable {
  final String? message;

  const SendRepots({this.message});

  factory SendRepots.fromJson(Map<String, dynamic> json) =>
      SendRepots(message: json['message'] as String?);

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
