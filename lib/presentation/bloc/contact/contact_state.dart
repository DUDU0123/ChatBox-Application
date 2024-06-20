part of 'contact_bloc.dart';

class ContactState extends Equatable {
  final List<ContactModel> contactList;
  const ContactState({required this.contactList});

  @override
  List<Object> get props => [contactList];
}

class ContactInitial extends ContactState {
  ContactInitial() : super(contactList: []);
}

class ContactsLoadingState extends ContactState {

  ContactsLoadingState() : super(contactList: []);
}

class ContactsFetchErrorState extends ContactState {
  final String message;
  ContactsFetchErrorState({
    required this.message,
  }) : super(contactList: []);
  @override
  List<Object> get props => [message,];
}
