/*
chat collection
===============
each chat have id
IN EACH CHAT:
------------
chat id
Message list => Messagemodel
message participants => sender, reciever
*/

import 'dart:developer';

import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/database_name_constants.dart';

class ChatData {
  final FirebaseFirestore firestore;
  ChatData({
    required this.firestore,
  });

  // // to check is the chat already exits in users chatbox account, if not it will create
  // checkIsChatExists(){}
  // // to generate a chat id for starting a chat with user initially
  // generateChatID(){}
  // // it will create a chat between to user
  // createNewChat(){
  //   // here need to check is chat exists
  //   // need to generate id for a chat , if not exist
  //   // create a new chat
  // }

  createChatID({required String currentUserID, required String receiverId})async{
   DocumentReference<Map<String, dynamic>> d =  await firestore.collection(usersCollection).doc(currentUserID).collection('chats').doc('$currentUserID$receiverId');
  }

  Future<UserModel?> getOneUserDataFromDataBase(
      {required String userId}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection(usersCollection).doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromJson(map: documentSnapshot.data()!);
      } else {
        log('User not found with ID: $userId');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while fetching user data: $e");
    } catch (e, stackTrace) {
      log('Error while fetching user data: $e', stackTrace: stackTrace);
      throw Exception("Error while fetching user data: $e");
    }
  }

}
