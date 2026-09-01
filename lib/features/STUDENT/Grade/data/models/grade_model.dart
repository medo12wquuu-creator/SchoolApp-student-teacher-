class GradeTypeModel {
  final String gradeType;
  final double maxScore;
  final double? score;
  final String? notes;

  GradeTypeModel({
    required this.gradeType,
    required this.maxScore,
    this.score,
    this.notes,
  });

  factory GradeTypeModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};
    return GradeTypeModel(
      gradeType:
          data['grade_type']?.toString() ??
          data['type']?.toString() ??
          data['name']?.toString() ??
          'Unknown',
      maxScore:
          double.tryParse(data['max_score']?.toString() ?? '0') ??
          double.tryParse(data['maxScore']?.toString() ?? '0') ??
          0,
      score: data['score'] == null
          ? null
          : double.tryParse(data['score']?.toString() ?? '0'),
      notes: data['notes']?.toString(),
    );
  }
}

class SubjectGradeModel {
  final String subject;
  final List<GradeTypeModel> types;
  final double totalScore;
  final double totalMax;

  SubjectGradeModel({
    required this.subject,
    required this.types,
    required this.totalScore,
    required this.totalMax,
  });

  bool get hasMarks => types.any((t) => t.score != null);

  factory SubjectGradeModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};
    final subject = data['subject']?.toString() ?? 'Unknown';

    final rawTypes = data['types'];
    final types = <GradeTypeModel>[];
    if (rawTypes is List) {
      for (final item in rawTypes) {
        if (item is Map<String, dynamic>) {
          types.add(GradeTypeModel.fromJson(item));
        } else if (item is Map) {
          types.add(GradeTypeModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    final totalScore =
        double.tryParse(data['total_score']?.toString() ?? '0') ?? 0;
    final totalMax = double.tryParse(data['total_max']?.toString() ?? '0') ?? 0;

    return SubjectGradeModel(
      subject: subject,
      types: types,
      totalScore: totalScore,
      totalMax: totalMax,
    );
  }
}

class GradeSummaryModel {
  final double studentTotal;
  final double totalMax;
  final int rankSection;
  final int rankClassroom;
  final int sectionSize;
  final int classSize;

  GradeSummaryModel({
    required this.studentTotal,
    required this.totalMax,
    required this.rankSection,
    required this.rankClassroom,
    required this.sectionSize,
    required this.classSize,
  });

  factory GradeSummaryModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};
    return GradeSummaryModel(
      studentTotal:
          double.tryParse(data['student_total']?.toString() ?? '0') ??
          double.tryParse(data['studentTotal']?.toString() ?? '0') ??
          0,
      totalMax:
          double.tryParse(data['total_max']?.toString() ?? '0') ??
          double.tryParse(data['totalMax']?.toString() ?? '0') ??
          0,
      rankSection:
          int.tryParse(data['rank_section']?.toString() ?? '0') ??
          int.tryParse(data['rankSection']?.toString() ?? '0') ??
          0,
      rankClassroom:
          int.tryParse(data['rank_classroom']?.toString() ?? '0') ??
          int.tryParse(data['rankClassroom']?.toString() ?? '0') ??
          0,
      sectionSize:
          int.tryParse(data['section_size']?.toString() ?? '0') ??
          int.tryParse(data['sectionSize']?.toString() ?? '0') ??
          0,
      classSize:
          int.tryParse(data['class_size']?.toString() ?? '0') ??
          int.tryParse(data['classSize']?.toString() ?? '0') ??
          0,
    );
  }
}

class SemesterModel {
  final int? semesterId;
  final String semesterName;
  final List<SubjectGradeModel> report;
  final GradeSummaryModel summary;

  SemesterModel({
    this.semesterId,
    required this.semesterName,
    required this.report,
    required this.summary,
  });

  bool get hasMarks => report.any((s) => s.hasMarks);

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    final rawReport = json['report'];
    final subjects = <SubjectGradeModel>[];
    if (rawReport is List) {
      for (final item in rawReport) {
        if (item is Map) {
          subjects.add(
            SubjectGradeModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    final summaryJson = json['summary'];
    return SemesterModel(
      semesterId: int.tryParse(json['semester_id']?.toString() ?? ''),
      semesterName: json['semester_name']?.toString() ?? '',
      report: subjects,
      summary: GradeSummaryModel.fromJson(
        summaryJson is Map ? Map<String, dynamic>.from(summaryJson) : null,
      ),
    );
  }
}

class GradePageModel {
  final List<SemesterModel> semesters;

  GradePageModel({required this.semesters});

  factory GradePageModel.fromJson(Map<String, dynamic> json) {
    final rawSemesters = json['semesters'] ?? json['data'];
    final semesters = <SemesterModel>[];

    if (rawSemesters is List) {
      for (final item in rawSemesters) {
        if (item is Map) {
          semesters.add(
            SemesterModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }
    return GradePageModel(semesters: semesters);
  }
}
