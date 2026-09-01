class UserModel {
  final int id;
  final String firstName;
  final String email;
  final String? phone;
  final String? avatar;
  final String role; // student or teacher

  UserModel({
    required this.id,
    required this.firstName,
    required this.email,
    this.phone,
    this.avatar,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse('${json["id"] ?? ""}') ?? 0,
      firstName:
          json["first_name"]?.toString() ?? json["name"]?.toString() ?? '',
      email: json["email"]?.toString() ?? '',
      phone: json["phone"]?.toString() ?? json["phone_number"]?.toString(),
      avatar: json["avatar"]?.toString() ?? json["personal_photo"]?.toString(),
      role:
          json["role"]?.toString() ?? json["role_id"]?.toString() ?? 'teacher',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "email": email,
      "phone": phone,
      "avatar": avatar,
      "role": role,
    };
  }
}
