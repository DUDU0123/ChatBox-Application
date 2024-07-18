import 'dart:developer';

import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chatbox/features/data/models/group_model/group_model.dart';

class GroupData {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  GroupData({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });
  Future<String?> createNewGroup({
    required GroupModel newGroupData,
  }) async {
    try {
      final User? currentser = firebaseAuth.currentUser;
      if (currentser == null) {
        return null;
      }
      if (newGroupData.groupMembers == null ||
          newGroupData.groupMembers!.isEmpty) {
        return null;
      }
      // Getting all user ids for creating group
      List<String> allUserIDs = [
        currentser.uid,
        ...newGroupData.groupMembers!.map((member) => member.id!)
      ];

      // here we are creating a group doc and getting the id for making the id of the group for all members the same
      final groupDocumentReference =
          firebaseFirestore.collection(groupsCollection).doc();

      final groupDocumentID = groupDocumentReference.id;

      GroupModel updatedGroupData =
          newGroupData.copyWith(groupID: groupDocumentID);

      WriteBatch batch = firebaseFirestore.batch();
      // setting the groupdata with id before setting it for all members
      batch.set(groupDocumentReference, updatedGroupData.toJson());

      // iterating through each user id and creating group in their groups collection using the id of the group doc before created
      for (String userID in allUserIDs) {
        final newDocumentRefernce = firebaseFirestore
            .collection(usersCollection)
            .doc(userID)
            .collection(groupsCollection)
            .doc(groupDocumentID);
        batch.set(newDocumentRefernce, {
          dbGroupId: groupDocumentID,
          dbGroupCreatedAt: FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
      log("Group created successfully with ID: $groupDocumentID");
      return groupDocumentID;
    } on FirebaseException catch (e) {
      log("From new group creation firebase: ${e.toString()}");
    } catch (e) {
      log("From new group creation catch: ${e.toString()}");
    }
    return null;
  }
}
