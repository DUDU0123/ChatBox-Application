import 'package:chatbox/features/domain/entities/contact_entity/contact_entity.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactModel extends ContactEntity {
  ContactModel({
    super.chatBoxUserId,
    super.userContactName,
    super.userAbout,
    super.userProfilePhotoOnChatBox,
    super.userContactNumber,
    super.isChatBoxUser,
  });

  factory ContactModel.fromJson(Contact contact){
    return ContactModel(
      userContactName: contact.displayName??'',
      userContactNumber: contact.phones.isNotEmpty? contact.phones.first.number:null,
      isChatBoxUser: false,
    );
  }
}
