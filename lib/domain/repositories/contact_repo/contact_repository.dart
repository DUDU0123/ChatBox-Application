import 'package:chatbox/data/models/contact_model/contact_model.dart';

abstract class ContactRepository{
  Future<List<ContactModel>> getAccessToUserContacts();
}