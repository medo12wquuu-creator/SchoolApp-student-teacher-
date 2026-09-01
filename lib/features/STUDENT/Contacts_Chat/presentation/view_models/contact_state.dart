import '../../data/models/contact_model.dart';

abstract class ContactState {
  bool get isLoading => false;
  String? get errorMessage => null;
  List<ContactModel> get contacts => const [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {
  @override
  bool get isLoading => true;
}

class ContactLoaded extends ContactState {
  @override
  final List<ContactModel> contacts;

  ContactLoaded(this.contacts);
}

class ContactError extends ContactState {
  final String message;

  ContactError(this.message);

  @override
  String? get errorMessage => message;
}
