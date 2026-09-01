import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import '../../data/repositories/contact_repository.dart';
import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactRepository repository;
  final UserCubit userCubit;

  ContactCubit(this.repository, this.userCubit) : super(ContactInitial());

  Future<void> loadContacts() async {
    if (!isClosed) emit(ContactLoading());

    try {
      final token = userCubit.token ?? '';
      final contacts = await repository.getContacts(token);
      if (!isClosed) emit(ContactLoaded(contacts));
    } catch (e) {
      if (!isClosed) emit(ContactError(e.toString()));
    }
  }
}
