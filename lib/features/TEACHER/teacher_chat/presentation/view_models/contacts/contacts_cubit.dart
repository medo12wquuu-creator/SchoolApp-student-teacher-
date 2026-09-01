import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/TEACHER/teacher_chat/data/repos/contacts_repo/contacts_repo.dart';

import 'contacts_state.dart';

/// نفس منطق ContactCubit في تطبيق الطالب — قائمة الطلاب المتاحين للمحادثة
class ContactsCubit extends Cubit<ContactsState> {
  final ContactsRepo repository;

  ContactsCubit(this.repository) : super(ContactsInitial());

  Future<void> loadContacts(int sectionId) async {
    emit(ContactsLoading());

    try {
      final result = await repository.getContacts(sectionId: sectionId);
      if (isClosed) return;

      result.fold(
        (failure) {
          if (!isClosed) emit(ContactsError(failure.errMassage));
        },
        (contacts) {
          if (!isClosed) emit(ContactsLoaded(contacts));
        },
      );
    } catch (e) {
      if (!isClosed) emit(ContactsError(e.toString()));
    }
  }
}
