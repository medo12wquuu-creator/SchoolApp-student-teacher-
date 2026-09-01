import 'package:dartz/dartz.dart';
import 'package:schooly/core/errors/failuree.dart';
import 'package:schooly/features/TEACHER/class_reports/data/models/class_report_model.dart';

abstract class ClassReportsRepo {
  Future<Either<Failure, List<ClassReportModel>>> fetchSectionReports({
    required String sectionId,
  });
  Future<Either<Failure, ClassReportModel>> modifyReport({
    required String reportId,
    String? title,
    String? description,
  });
  Future<Either<Failure, ClassReportModel>> deleteReport({
    required String reportId,
  });
}
