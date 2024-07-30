import 'package:chatbox/core/constants/database_name_constants.dart';
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

  factory ContactModel.fromjson(Map<String, dynamic> json) {
    return ContactModel(
      chatBoxUserId: json[dbChatBoxUserId] as String?,
      userContactName: json[dbUserContactName] as String?,
      userAbout: json[dbUserAbout] as String?,
      userProfilePhotoOnChatBox: json[dbUserProfilePhotoOnChatBox] as String?,
      userContactNumber: json[dbUserContactNumber] as String?,
      isChatBoxUser: json[dbIsChatBoxUser] as bool?,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      dbChatBoxUserId: chatBoxUserId,
      dbUserContactName: userContactName,
      dbUserAbout: userAbout,
      dbUserProfilePhotoOnChatBox: userProfilePhotoOnChatBox,
      dbUserContactNumber: userContactNumber,
      dbIsChatBoxUser: isChatBoxUser,
    };
  }
}
