import 'package:equatable/equatable.dart';

class Pivot extends Equatable {
  final int? teacherId;
  final int? sectionId;

  const Pivot({this.teacherId, this.sectionId});

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    teacherId: json['teacher_id'] as int?,
    sectionId: json['section_id'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'teacher_id': teacherId,
    'section_id': sectionId,
  };

  @override
  List<Object?> get props => [teacherId, sectionId];
}
