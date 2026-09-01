import 'package:equatable/equatable.dart';
import 'conversation.dart';

class SectionConversationModel extends Equatable {
  final int? sectionId;
  final String? sectionName;
  final List<Conversation>? conversations;

  const SectionConversationModel({
    this.sectionId,
    this.sectionName,
    this.conversations,
  });

  factory SectionConversationModel.fromJson(Map<String, dynamic> json) {
    // 1. استخراج الـ ID بأي اسم محتمل وتفادي أخطاء الأنواع (int / String)
    final rawId = json['section_id'] ?? json['id'] ?? json['sectionId'];
    final parsedId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '');

    // 2. استخراج اسم الشعبة بأي اسم محتمل
    final rawName =
        json['section_name'] ??
        json['name'] ??
        json['title'] ??
        json['sectionName'];

    // 3. قراءة قائمة المحادثات بأمان تام بدون أن ترمي Exception
    List<Conversation> convList = [];
    final rawConvs = json['conversations'] ?? json['chats'] ?? json['data'];

    if (rawConvs is List) {
      for (var item in rawConvs) {
        if (item is Map<String, dynamic>) {
          try {
            convList.add(Conversation.fromJson(item));
          } catch (e) {
            print("Error parsing conversation item: $e");
          }
        }
      }
    }

    return SectionConversationModel(
      sectionId: parsedId,
      sectionName: rawName?.toString() ?? 'شعبة $parsedId',
      conversations: convList,
    );
  }

  Map<String, dynamic> toJson() => {
    'section_id': sectionId,
    'section_name': sectionName,
    'conversations': conversations?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [sectionId, sectionName, conversations];
}
