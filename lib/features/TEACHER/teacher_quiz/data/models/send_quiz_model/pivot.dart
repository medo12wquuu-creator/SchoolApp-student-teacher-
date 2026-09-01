import 'package:equatable/equatable.dart';

class Pivot extends Equatable {
  final int? examId;
  final int? sectionId;

  const Pivot({this.examId, this.sectionId});

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    examId: json['exam_id'] as int?,
    sectionId: json['section_id'] as int?,
  );

  Map<String, dynamic> toJson() => {'exam_id': examId, 'section_id': sectionId};

  @override
  List<Object?> get props => [examId, sectionId];
}
