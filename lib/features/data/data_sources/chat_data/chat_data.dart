// /*
// chat collection
// ===============
// each chat have id
// IN EACH CHAT:
// ------------
// chat id
// Message list => Messagemodel
// message participants => sender, reciever
// */
// import 'dart:developer';

// import 'package:chatbox/core/constants/database_name_constants.dart';
// import 'package:chatbox/core/enums/enums.dart';
// import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
// import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
// import 'package:chatbox/features/data/models/message_model/message_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatData {
//   final FirebaseFirestore firestore;
//   final FirebaseAuth firebaseAuth;
//   ChatData({
//     required this.firestore,
//     required this.firebaseAuth,
//   });

//   // method to generate a chat id by combining the id of receiver and sender
//   String _generateChatId(
//       {required String currentUserId, required String receiverId}) {
//     try {
//       List uids = [currentUserId, receiverId];
//     uids.sort();
//     String chatID = uids.fold("", (id, uid) => "$id$uid");
//     return chatID;
//     } catch (e) {
//       log(name: "Chat Id generate error: ",e.toString());
//       throw Exception(e.toString());
//     }
//   }

//   Future<bool> checkIfChatExistAlready(
//       String currentUserId, String contactId) async {
//     try {

//     } on FirebaseAuthException catch (e) {
//       log("From Chat Data: 47: ${e.message}");
//       throw Exception(e.message);
//     } catch (e) {
//       log(e.toString());
//       throw Exception(e.toString());
//     }
//   }

//   Future<void> createANewChat({required ContactModel contactModel}) async {
//     try {

//     } on FirebaseAuthException catch (e) {
//       log("From Chat Data: 82: ${e.message}");
//       throw Exception(e.message);
//     } catch (e) {
//       log(e.toString());
//       throw Exception(e.toString());
//     }
//   }

//   // get all chat, so we can show it in the chat home page
//   Stream<List<ChatModel>> getAllChatsFromDB() {
//     try {

//     } on FirebaseAuthException catch (e) {
//       log("From Chat Data: 107: ${e.message}");
//       throw Exception(e.message);
//     } catch (e) {
//       log(e.toString());
//       throw Exception(e.toString());
//     }
//   }

//   // get all messages in a chat
//   Stream<List<MessageModel>> getAllMessagesFromDB({required String chatId}) {
//     try {

//     } on FirebaseAuthException catch (e) {
//       log("From Chat Data: 129: ${e.message}");
//       throw Exception(e.message);
//     } catch (e) {
//       log(e.toString());
//       throw Exception(e.toString());
//     }
//   }

//   // get one message from a chat
//   Future<MessageModel> getOneMessageFromDB(
//       {required String chatId, required String messageId}) async {
//     try {

//     } on FirebaseAuthException catch (e) {
//       log("From Chat Data: 155: ${e.message}");
//       throw Exception(e.message);
//     } catch (e) {
//       log(e.toString());
//       throw Exception(e.toString());
//     }
//   }

// // send a message to a chat
//   Future<void> sendMessageToAChat(
//       {required String chatId, required MessageModel message}) async {
//     try {

//     } on FirebaseAuthException catch (e) {
//       log("From Chat Data: 174: ${e.message}");
//       throw Exception(e.message);
//     } catch (e) {
//       log(e.toString());
//       throw Exception(e.toString());
//     }
//   }
//   // delete a message in a chat
//   Future<void> deleteMessageInAChat(
//       {required String chatId, required String messageId}) async {
//     try {

//     } on FirebaseAuthException catch (e) {
//       log("From Chat Data: 193: ${e.message}");
//       throw Exception(e.message);
//     } catch (e) {
//       log(e.toString());
//       throw Exception(e.toString());
//     }
//   }

// // edit a message in a chat
//   Future<void> editMessageInAChat(
//       {required String chatId,
//       required String messageId,
//       required MessageModel updatedData}) async {
//     try {

//     } on FirebaseAuthException catch (e) {
//       log("From Chat Data: 214: ${e.message}");
//       throw Exception(e.message);
//     } catch (e) {
//       log(e.toString());
//       throw Exception(e.toString());
//     }
//   }
// }
import 'dart:developer';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatbox/core/constants/database_name_constants.dart';
class ChatData {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatData({
    required this.firestore,
    required this.firebaseAuth,
  });

  // Method to generate a chat ID by combining the IDs of receiver and sender
  String _generateChatId(
      {required String currentUserId, required String receiverId}) {
    try {
      List<String> uids = [currentUserId, receiverId];
      uids.sort();
      String chatID = uids.fold("", (id, uid) => "$id$uid");
      return chatID;
    } catch (e) {
      log(name: "Chat Id generate error: ", e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> checkIfChatExistAlready(
      String currentUserId, String contactId) async {
    try {
      String chatId =
          _generateChatId(currentUserId: currentUserId, receiverId: contactId);
      DocumentSnapshot chatSnapshot = await firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .get();
      return chatSnapshot.exists;
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
      log("Contact Model User Id: ${contactModel.chatBoxUserId}");
      String currentUserId = firebaseAuth.currentUser!.uid;
      String chatId = _generateChatId(
        currentUserId: currentUserId,
        receiverId: contactModel.chatBoxUserId!,
      );
      ChatModel chat = ChatModel(
        chatID: chatId,
        senderID: currentUserId,
        receiverID: contactModel.chatBoxUserId,
        lastMessage: null,
        lastMessageTime: DateTime.now().toString(),
        lastMessageStatus: MessageStatus.none,
        lastMessageType: MessageType.none,
        notificationCount: 0,
        receiverName: contactModel.userContactName,
        receiverProfileImage: contactModel.userProfilePhotoOnChatBox,
        isMuted: false,
      );

      await firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .set(chat.toJson());
      await firestore
          .collection(usersCollection)
          .doc(contactModel.chatBoxUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .set(chat.toJson());
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 82: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Stream<List<ChatModel>> getAllChatsFromDB() {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      log("CurrentID: ${currentUserId}");
        
         final val =  firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromJson(doc.data()))

              .toList());
              val.listen((data)=>log("Id: ${data[0].chatID} name: ${data[0].receiverName} Imageee: ${data[0].receiverProfileImage}"));
      return firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromJson(doc.data()))
              .toList());
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 107: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Stream<List<MessageModel>> getAllMessagesFromDB({required String chatId}) {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      return firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromJson(map: doc.data()))
              .toList());
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 129: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<MessageModel> getOneMessageFromDB(
      {required String chatId, required String messageId}) async {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      DocumentSnapshot doc = await firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .doc(messageId)
          .get();
      return MessageModel.fromJson(map: doc.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 155: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> sendMessageToAChat(
      {required String chatId, required MessageModel message}) async {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      await firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .doc(message.messageId)
          .set(message.toJson());
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 174: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> deleteMessageInAChat(
      {required String chatId, required String messageId}) async {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      await firestore
          .collection(usersCollection)
          .doc(currentUserId)
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

  Future<void> editMessageInAChat({
    required String chatId,
    required String messageId,
    required MessageModel updatedData,
  }) async {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      await firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .doc(messageId)
          .update(updatedData.toJson());
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 214: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }
}
