import 'package:dartz/dartz.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/students/data/models/add_note/add_note.dart';
import 'package:schooly/features/TEACHER/students/data/models/fetch_student_reports/fetch_student_reports.dart';
import 'package:schooly/features/TEACHER/students/data/models/notes_model/notes_model.dart';
import 'package:schooly/features/TEACHER/students/data/models/send_repots.dart';


abstract class StudentDetailsRepo {
  Future<Either<Failure, List<NotesModel>>> fetchStudentNotes({
    required String studentId,
  });
  Future<Either<Failure, AddNote>> sendStudentNote({
    required String studentId,
    required String subjectId,
    required String semesterId,
    required String type,
    required String body,
  });
  Future<Either<Failure, List<FetchStudentReports>>> fetchStudentReports({
    required String studentId,
  });
  Future<Either<Failure, SendRepots>> sendStudentReport({
    required String studentId,
    required String title,
    required String description,
    required String type,
  });
  Future<Either<Failure, FetchStudentReports>> modifyStudentReport({
    required String reportId,
    String? title,
    String? description,
  });
  Future<Either<Failure, FetchStudentReports>> deleteStudentReport({
    required String reportId,
  });
}
