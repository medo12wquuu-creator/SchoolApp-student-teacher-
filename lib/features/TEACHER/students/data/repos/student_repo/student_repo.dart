import 'package:dartz/dartz.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_students_model/fetch_students_model.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_weights_model/fetch_weights_model.dart';

/// نتيجة جلب الطلاب: الطلاب + الأوزان (مجمّعة في استجابة واحدة /sectionGrade)
typedef StudentsAndWeights = ({
  List<FetchStudentsModel> students,
  List<FetchWeightsModel> weights,
});

abstract class StudentRepo {
  Future<Either<Failure, StudentsAndWeights>> fetchStudents({
    required String sectionId,
    required String semesterId, // تعديل هنا
  });

  Future<Either<Failure, void>> sendSingleMark({
    required String sectionId,
    required String semesterId,
    required String studentId,
    required String weightId,
    required String score,
  });

  Future<Either<Failure, List<FetchWeightsModel>>> fetchWheights({
    required String sectionId,
    required String semesterId, // تعديل هنا
  });
}
