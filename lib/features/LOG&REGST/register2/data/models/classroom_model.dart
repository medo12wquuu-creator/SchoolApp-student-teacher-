class ClassroomModel {
  final int id;
  final String name;
  final int? stageId;
  final int? employeeId;
  final int? order;
  final String? createdAt;
  final String? updatedAt;

  const ClassroomModel({
    required this.id,
    required this.name,
    this.stageId,
    this.employeeId,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    return ClassroomModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      stageId: json['stage_id'] as int?,
      employeeId: json['employee_id'] as int?,
      order: json['order'] as int?,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
