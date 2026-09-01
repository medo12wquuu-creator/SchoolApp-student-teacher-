import 'package:equatable/equatable.dart';

import 'class_a.dart';
import 'class_b.dart';

/// الشعب المجمّعة — تدعم أي مفتاح (اسم الصف مثل "الصف الثاني" أو "Class A/B")
class Sections extends Equatable {
  final List<ClassA>? classA;
  final List<ClassB>? classB;

  const Sections({this.classA, this.classB});

  factory Sections.fromJson(Map<String, dynamic> json) {
    // 📌 نسخة جديدة: الباك يرسل الشعب مجمّعة بمفتاح اسم الصف (مثل "الصف الثاني")
    // أو المفاتيح القديمة (Class A / Class B) — ندمج كل القوائم في قائمة واحدة.
    final all = <ClassA>[];
    final classB = <ClassB>[];

    json.forEach((key, value) {
      if (value is! List) return;
      if (key == 'Class B') {
        for (final e in value) {
          if (e is Map<String, dynamic>) classB.add(ClassB.fromJson(e));
        }
      } else {
        for (final e in value) {
          if (e is Map<String, dynamic>) all.add(ClassA.fromJson(e));
        }
      }
    });

    return Sections(classA: all, classB: classB);
  }

  Map<String, dynamic> toJson() => {
    'Class A': classA?.map((e) => e.toJson()).toList(),
    'Class B': classB?.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [classA, classB];
}