import 'package:equatable/equatable.dart';

class TakeAttendanceModel extends Equatable {
  final String? message;
  final int? sessionId;

  const TakeAttendanceModel({this.message, this.sessionId});

  factory TakeAttendanceModel.fromJson(Map<String, dynamic> json) {
    return TakeAttendanceModel(
      message: json['message'] as String?,
      sessionId: json['session_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'session_id': sessionId,
  };

  @override
  List<Object?> get props => [message, sessionId];
}
