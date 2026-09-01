class ContactModel {
  final int id;
  final String name;
  final String personalPhoto;
  final int? conversationId;

  const ContactModel({
    required this.id,
    required this.name,
    required this.personalPhoto,
    required this.conversationId,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      personalPhoto: json['personal_photo'] as String? ?? '',
      conversationId: json['conversation_id'] as int?,
    );
  }

  String get photoUrl => personalPhoto;
}
