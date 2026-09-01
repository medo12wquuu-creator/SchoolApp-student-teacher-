import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:schooly/core/constants/api_constants.dart';
import 'package:schooly/core/errors/failure.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/models/contact_model.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/repos/contacts_repo/contacts_repo.dart';

class ContactsRepoImp implements ContactsRepo {
  final ApiService _api;
  ContactsRepoImp(this._api);

  @override
  Future<Either<Failure, List<ContactModel>>> getContacts({
    required int sectionId,
  }) async {
    try {
      final response = await _api.get(
        endPoint: '/chat/sections/$sectionId/contacts',
      );
      final List<dynamic> rawList;
      if (response is Map && response['data'] is List) {
        rawList = response['data'] as List<dynamic>;
      } else if (response is List) {
        rawList = response;
      } else {
        return left(ServerFailure('استجابة غير متوقعة'));
      }
      final contacts = rawList
          .map((e) => ContactModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(contacts);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
