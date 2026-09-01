class AnnouncementModel {
  final int id;
  final String title;
  final String body;
  final String date;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json["created_at"] as String? ?? "";
    final dateOnly = rawDate.length >= 10 ? rawDate.substring(0, 10) : rawDate;

    return AnnouncementModel(
      id: json["id"] as int? ?? 0,
      title: json["title"] as String? ?? "",
      body: json["body"] as String? ?? "",
      date: dateOnly,
    );
  }
}
