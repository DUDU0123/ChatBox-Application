import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:chatbox/data/models/contact_model/contact_model.dart';
import 'package:chatbox/domain/repositories/contact_repo/contact_repository.dart';
import 'package:equatable/equatable.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository contactRepository;
  ContactBloc({required this.contactRepository}) : super(ContactInitial()) {
    on<GetContactsEvent>(getContactsEvent);
  }

  Future<FutureOr<void>> getContactsEvent(
      GetContactsEvent event, Emitter<ContactState> emit) async {
        emit(ContactsLoadingState());
    try {
      log("Hello");
      final List<ContactModel> contacts =
          await contactRepository.getAccessToUserContacts();
          log(contacts.length.toString());
      emit(ContactState(contactList: contacts));
    } catch (e) {
      log("Error $e");
      emit(ContactsFetchErrorState(message: e.toString()));
    }
  }
}
