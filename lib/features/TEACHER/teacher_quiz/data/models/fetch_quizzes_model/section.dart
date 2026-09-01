import 'package:equatable/equatable.dart';

class Section extends Equatable {
  final int? id;
  final String? name;

  const Section({this.id, this.name});

  factory Section.fromJson(Map<String, dynamic> json) =>
      Section(id: json['id'] as int?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}
