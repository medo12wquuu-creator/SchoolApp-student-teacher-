import 'package:equatable/equatable.dart';

class EditPasswordModel extends Equatable {
  final String? message;

  const EditPasswordModel({this.message});

  factory EditPasswordModel.fromJson(Map<String, dynamic> json) {
    return EditPasswordModel(message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() => {'message': message};

  @override
  List<Object?> get props => [message];
}
