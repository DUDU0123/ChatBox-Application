import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatbox/data/data_sources/contact_data/contact_data.dart';
import 'package:chatbox/data/models/contact_model/contact_model.dart';
import 'package:chatbox/domain/repositories/contact_repo/contact_repository.dart';

class ContactRepoImpl extends ContactRepository {
  final ContactData contactData;
  final FirebaseFirestore firebaseFirestore;
  ContactRepoImpl({
    required this.contactData,
    required this.firebaseFirestore,
  });
  // @override
  // Future<List<ContactModel>> getAccessToUserContacts() async {
  //   List<ContactModel> contactsModelList = [];
  //   try {
  //     final contacts = await contactData.getContactsInUserDevice();
  //     for (Contact contact in contacts) {
  //       var contactModel = ContactModel.fromJson(contact);

  //       if (contactModel.userContactNumber != null) {
  //         var userSnapShot = await firebaseFirestore
  //             .collection(usersCollection)
  //             .where(userDbPhoneNumber,
  //                 isEqualTo: contactModel.userContactNumber)
  //             .get();

  //         if (userSnapShot.docs.isNotEmpty) {
  //           var userData = userSnapShot.docs.first;
  //           contactModel = ContactModel(
  //               chatBoxUserId: userData[userDbId],
  //               userAbout: userData[userDbAbout],
  //               userContactName: contactModel.userContactName,
  //               userContactNumber: contactModel.userContactNumber,
  //               userProfilePhotoOnChatBox: userData[userDbProfileImage]);
  //         }
  //       }
  //       contactsModelList.add(contactModel);
  //     }
  //     return contactsModelList;
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }
   @override
  Future<List<ContactModel>> getAccessToUserContacts() async {
    List<ContactModel> contactsModelList = [];
    try {
      final contacts = await contactData.getContactsInUserDevice();
      final phoneNumbers = contacts
          .where((contact) => contact.phones.isNotEmpty)
          .map((contact) => contact.phones.first.number)
          .toList();

      // Batch Firestore queries
      final userSnapshots = await Future.wait(phoneNumbers.map((phoneNumber) {
        return firebaseFirestore
            .collection(usersCollection)
            .where(userDbPhoneNumber, isEqualTo: phoneNumber)
            .get();
      }));

      // Create a map of phone numbers to Firestore data
      final userMap = <String, Map<String, dynamic>>{};
      for (var snapshot in userSnapshots) {
        if (snapshot.docs.isNotEmpty) {
          var userData = snapshot.docs.first.data();
          userMap[userData[userDbPhoneNumber]] = userData;
        }
      }

      for (var contact in contacts) {
        var contactModel = ContactModel.fromJson(contact);
        if (contactModel.userContactNumber != null &&
            userMap.containsKey(contactModel.userContactNumber)) {
          var userData = userMap[contactModel.userContactNumber]!;
          contactModel = ContactModel(
            chatBoxUserId: userData[userDbId],
            userContactName: contactModel.userContactName,
            userAbout: userData[userDbAbout],
            userProfilePhotoOnChatBox: userData[userDbProfileImage],
            userContactNumber: contactModel.userContactNumber,
            isChatBoxUser: true,
          );
        }
        contactsModelList.add(contactModel);
      }

      return contactsModelList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
