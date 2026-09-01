import 'package:schooly/features/TEACHER/teacher_chat/data/models/contact_model.dart';

abstract class ContactsState {
  bool get isLoading => false;
  String? get errorMessage => null;
  List<ContactModel> get contacts => const [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {
  @override
  bool get isLoading => true;
}

class ContactsLoaded extends ContactsState {
  @override
  final List<ContactModel> contacts;

  ContactsLoaded(this.contacts);
}

class ContactsError extends ContactsState {
  final String message;

  ContactsError(this.message);

  @override
  String? get errorMessage => message;
}
