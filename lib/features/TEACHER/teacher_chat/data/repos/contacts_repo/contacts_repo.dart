import 'package:dartz/dartz.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/contact_model.dart';


abstract class ContactsRepo {
  /// جلب قائمة الطلاب المتاحين للمحادثة في شعبة معينة
  Future<Either<Failure, List<ContactModel>>> getContacts({
    required int sectionId,
  });
}
