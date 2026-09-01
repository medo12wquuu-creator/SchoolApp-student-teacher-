class UserModel {
  final int id;
  final String first_name;
  final String email;
  final String? phone;
  final String? avatar;
  final String role; // student or teacher

  UserModel({
    required this.id,
    required this.first_name,
    required this.email,
    this.phone,
    this.avatar,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      first_name: json["first_name"],
      email: json["email"],
      phone: json["phone"],
      avatar: json["avatar"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": first_name,
      "email": email,
      "phone": phone,
      "avatar": avatar,
      "role": role,
    };
  }
}
