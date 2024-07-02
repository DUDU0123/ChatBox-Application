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

import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatData {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  ChatData({
    required this.firestore,
    required this.firebaseAuth,
  });

  // method to generate a chat id by combining the id of receiver and sender
  String _generateChatId(
      {required String currentUserId, required String receiverId}) {
    try {
      List uids = [currentUserId, receiverId];
    uids.sort();
    String chatID = uids.fold("", (id, uid) => "$id$uid");
    return chatID;
    } catch (e) {
      log(name: "Chat Id generate error: ",e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> checkIfChatExistAlready(
      String currentUserId, String contactId) async {
    try {
      final chatId =
          _generateChatId(currentUserId: currentUserId, receiverId: contactId);
      final chatDoc =
          await firestore.collection(chatsCollection).doc(chatId).get();
      return chatDoc.exists;
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 47: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> createANewChat({required ContactModel contactModel}) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception("No user is signed in");
      }

      final chatId = _generateChatId(
        currentUserId: currentUser.uid,
        receiverId: contactModel.chatBoxUserId!,
      );

      final chatData = ChatModel(
        chatID: chatId,
        senderID: currentUser.uid,
        receiverID: contactModel.chatBoxUserId,
        lastMessage: '',
        lastMessageTime: DateTime.now().toString(),
        lastMessageStatus: MessageStatus.sent,
        lastMessageType: MessageType.text,
        notificationCount: 0,
        recieverProfileImage: contactModel.userProfilePhotoOnChatBox,
        isMuted: false,
      ).toJson();

      await firestore.collection(chatsCollection).doc(chatId).set(chatData);
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 82: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  // get all chat, so we can show it in the chat home page
  Stream<List<ChatModel>> getAllChatsFromDB() {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception("No user is signed in");
      }

      return firestore
          .collection(chatsCollection)
          .where('senderID', isEqualTo: currentUser.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  ChatModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList());
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 107: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  // get all messages in a chat
  Stream<List<MessageModel>> getAllMessagesFromDB({required String chatId}) {
    try {
      return firestore
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .orderBy('messageTime')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromJson(
                  map: doc.data() as Map<String, dynamic>))
              .toList());
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 129: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  // get one message from a chat
  Future<MessageModel> getOneMessageFromDB(
      {required String chatId, required String messageId}) async {
    try {
      final messageDoc = await firestore
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .doc(messageId)
          .get();

      if (messageDoc.exists) {
        return MessageModel.fromJson(
            map: messageDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception("Message not found");
      }
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 155: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

// send a message to a chat
  Future<void> sendMessageToAChat(
      {required String chatId, required MessageModel message}) async {
    try {
      final messageData = message.toJson();
      await firestore
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .add(messageData);
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 174: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  // delete a message in a chat
  Future<void> deleteMessageInAChat(
      {required String chatId, required String messageId}) async {
    try {
      await firestore
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .doc(messageId)
          .delete();
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 193: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

// edit a message in a chat
  Future<void> editMessageInAChat(
      {required String chatId,
      required String messageId,
      required MessageModel updatedData}) async {
    try {
      final editedMessage = updatedData.toJson();
      await firestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesCollection)
        .doc(messageId)
        .update(editedMessage);
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 214: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }
}
