import 'package:dartz/dartz.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/fetch_attendance/take_attendance.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/fetch_homework_and_task_model/fetch_homework_and_task_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/send_class_report_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/send_homework_and_task_model.dart';
import 'package:schooly/features/TEACHER/teacher_classes/data/models/take_attendance_model.dart';


abstract class ClassDetailsRepo {
  Future<Either<Failure, SendHomeworkAndTaskModel>> sendHomework({
    required String sectionId,
    required String type,
    required String title,
    required String description,
    required String deliveryDate,
    int? subjectId,
  });
  Future<Either<Failure, SendHomeworkAndTaskModel>> sendTask({
    required String sectionId,
    required String type,
    required String title,
    required String description,
    required String deliveryDate,
    int? subjectId,
  });
  Future<Either<Failure, List<FetchHomeworkAndTaskModel>>> fetchHomework(
    String sectionId,
  );
  Future<Either<Failure, List<FetchHomeworkAndTaskModel>>> fetchTasks(
    String sectionId,
  );
  Future<Either<Failure, FetchAttendanceModel>> fetchAttendance({
    required String sectionId,
  });
  Future<Either<Failure, TakeAttendanceModel>> takeAttendance({
    required String sectionId,
    required List<Map<String, dynamic>> attendances,
  });
  Future<Either<Failure, SendClassReportModel>> sendClassReport({
    required String sectionId,
    required String title,
    required String description,
  });
  Future<Either<Failure, TakeAttendanceModel>> modifyAttendance({
    required String sectionId,
    required List<Map<String, dynamic>> attendances,
  });
Future<Either<Failure, dynamic>> deleteTaskHomework(int id);
    
}
