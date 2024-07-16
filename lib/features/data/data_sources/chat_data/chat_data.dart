// chat id
// Message list => Messagemodel
// message participants => sender, reciever

import 'dart:developer';
import 'dart:io';
import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/features/data/data_sources/user_data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class ChatData {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatData({
    required this.firestore,
    required this.firebaseAuth,
  });

  // Method to generate a chat ID by combining the IDs of receiver and sender
  static String generateChatId(
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

  static Stream<MessageModel> getMessageStream(
      String chatID, String messageID) {
    return fireStore
        .collection(chatsCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .doc(messageID)
        .snapshots()
        .map(
          (event) => MessageModel.fromJson(
            map: event.data() ?? {},
          ),
        );
  }

  Future<bool> checkIfChatExistAlready(
      String currentUserId, String contactId) async {
    try {
      String chatId =
          generateChatId(currentUserId: currentUserId, receiverId: contactId);
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

  Stream<UserModel?> getOneUserDataFromDataBaseAsStream(
      {required String userId}) {
    try {
      return firestore.collection(usersCollection).doc(userId).snapshots().map(
            (event) => UserModel.fromJson(
              map: event.data() ?? {},
            ),
          );
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

  Future<void> createANewChat({
    required String receiverId,
    required String receiverContactName,
  }) async {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      String chatId = generateChatId(
        currentUserId: currentUserId,
        receiverId: receiverId,
      );

      final Stream<UserModel?> receiverDataStream =
          getOneUserDataFromDataBaseAsStream(userId: receiverId);
      final Stream<UserModel?> currentUserDataStream =
          getOneUserDataFromDataBaseAsStream(userId: currentUserId);
      receiverDataStream.listen((UserModel? data) async {
        if (data != null) {
          ChatModel chat = ChatModel(
            chatID: chatId,
            senderID: currentUserId,
            receiverID: data.id,
            lastMessage: "",
            lastMessageTime: DateTime.now().toString(),
            lastMessageStatus: MessageStatus.none,
            lastMessageType: MessageType.none,
            notificationCount: 0,
            receiverName: receiverContactName,
            receiverProfileImage: data.userProfileImage,
            isMuted: false,
          );

          await firestore
              .collection(usersCollection)
              .doc(currentUserId)
              .collection(chatsCollection)
              .doc(chatId)
              .set(chat.toJson());
        } else {
          throw Exception("User data is null");
        }
      });

      currentUserDataStream.listen((UserModel? data) async {
        if (data != null) {
          ChatModel chat = ChatModel(
            chatID: chatId,
            senderID: receiverId,
            receiverID: currentUserId,
            lastMessage: "",
            lastMessageTime: DateTime.now().toString(),
            lastMessageStatus: MessageStatus.none,
            lastMessageType: MessageType.none,
            notificationCount: 0,
            receiverName: data.userName,
            receiverProfileImage: data.userProfileImage,
            isMuted: false,
          );

          await firestore
              .collection(usersCollection)
              .doc(receiverId)
              .collection(chatsCollection)
              .doc(chatId)
              .set(chat.toJson());
        } else {
          throw Exception("User data is null");
        }
      });
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth exception: ${e.message}");
      throw Exception("Error while creating chat: ${e.message}");
    } catch (e, stackTrace) {
      log("Error while creating chat: $e", stackTrace: stackTrace);
      throw Exception("Error while creating chat: $e");
    }
  }

  Future<void> sendMessageToAChat({
    required String? chatId,
    required MessageModel message,
    required String receiverId,
    required String receiverContactName,
  }) async {
    try {
      final String? currentUserId = firebaseAuth.currentUser?.uid;
      if (currentUserId == null) {
        return;
      }
      if (message.senderID == message.receiverID) {
        await firestore
            .collection(usersCollection)
            .doc(message.senderID)
            .collection(chatsCollection)
            .doc(chatId)
            .collection(messagesCollection)
            .doc(message.messageId)
            .set(message.toJson());
      } else {
        await firestore
            .collection(usersCollection)
            .doc(message.senderID)
            .collection(chatsCollection)
            .doc(chatId)
            .collection(messagesCollection)
            .doc(message.messageId)
            .set(message.toJson());
        await firestore
            .collection(usersCollection)
            .doc(message.receiverID)
            .collection(chatsCollection)
            .doc(chatId)
            .collection(messagesCollection)
            .doc(message.messageId)
            .set(message.toJson());
      }
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 241: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<String> sendAssetMessage({
    required String chatID,
    required File file,
  }) async {
    try {
      final assetUrl = await saveUserFileToDataBaseStorage(
          ref: "$chatAssetFolder$chatID/${DateTime.now()}", file: file);
      return assetUrl;
    } on FirebaseAuthException catch (e) {
      log("Photo send error chat data: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  static void listenToChatDocument(String userId, String chatId) {
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(userId)
        .collection(chatsCollection)
        .doc(chatId)
        .snapshots()
        .listen((DocumentSnapshot docSnapshot) {
      if (docSnapshot.exists) {
        // Check if the chat is opened
        ChatModel chat =
            ChatModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
        if (chat.isChatOpen ?? false) {
          // Handle the case when the chat is opened
          log(
              name: "Checking chat open or not",
              'Chat is opened by the receiver ${chat.isChatOpen}');
        }
      }
    });
  }

  // this method will update isChatOpen parameter when user open one chat and close it
  static void updateChatOpenStatus(String userId, String chatId, bool isOpen) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .update({'isChatOpen': isOpen});
  }

static void updateChatMessageDataOfUser({
  required ChatModel? chatModel,
  required MessageModel message,
}) async {
  if (chatModel?.senderID == null || chatModel?.receiverID == null) {
    return;
  }
  if (chatModel == null) {
    return;
  }
  
  String messageType = '';
  String lastMessage = '';
  String messageStatus = MessageStatus.none.name;

  // Determine the message type and last message string
  switch (message.messageType) {
    case MessageType.audio:
      messageType = 'audio';
      lastMessage = '🎧Audio';
      break;
    case MessageType.contact:
      messageType = 'contact';
      lastMessage = '📞Contact';
      break;
    case MessageType.document:
      messageType = 'document';
      lastMessage = '📄Doc';
      break;
    case MessageType.photo:
      messageType = 'photo';
      lastMessage = '📷Photo';
      break;
    case MessageType.video:
      messageType = 'video';
      lastMessage = '🎥Video';
      break;
    case MessageType.location:
      messageType = 'location';
      lastMessage = '📌Location';
      break;
    default:
      lastMessage = message.message ?? '';
      messageType = 'text';
  }

  // Fetch receiver data
  final receiverSnapshot = await FirebaseFirestore.instance
      .collection(usersCollection)
      .doc(chatModel.receiverID)
      .get();
  
  if (receiverSnapshot.exists) {
    final receiverData = UserModel.fromJson(map: receiverSnapshot.data()!);

    bool isChatOpen = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(chatModel.receiverID)
        .collection(chatsCollection)
        .doc(chatModel.chatID)
        .get()
        .then((doc) => doc['isChatOpen'] ?? false);

    if (receiverData.userNetworkStatus! && isChatOpen) {
      messageStatus = MessageStatus.read.name;
    } else if (receiverData.userNetworkStatus! && !isChatOpen) {
      messageStatus = MessageStatus.delivered.name;
    } else if (!receiverData.userNetworkStatus!) {
      messageStatus = MessageStatus.sent.name;
    }

    // Update sender's chat document
    await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(chatModel.senderID)
        .collection(chatsCollection)
        .doc(chatModel.chatID)
        .update({
      chatLastMessageTime: message.messageTime,
      lastChatType: messageType,
      chatLastMessage: lastMessage,
      lastChatStatus: messageStatus,
      isIncoming: message.senderID == chatModel.receiverID,
    });

    // Update receiver's chat document
    await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(chatModel.receiverID)
        .collection(chatsCollection)
        .doc(chatModel.chatID)
        .update({
      chatLastMessageTime: message.messageTime,
      lastChatType: messageType,
      chatLastMessage: lastMessage,
      lastChatStatus: messageStatus,
      isIncoming: message.senderID != chatModel.receiverID,
    });

    await FirebaseFirestore.instance.collection(usersCollection)
        .doc(chatModel.receiverID)
        .collection(chatsCollection)
        .doc(chatModel.chatID).collection(messagesCollection).doc(message.messageId).update({
          dbMessageStatus: messageStatus,
        });
  } else {
    throw Exception("Receiver user data not found");
  }
}

// static void updateChatMessageDataOfUser({
//   required ChatModel? chatModel,
//   required MessageModel message,
// }) async {
//   if (chatModel?.senderID == null || chatModel?.receiverID == null) {
//     return;
//   }
//   if (chatModel == null) {
//     return;
//   }
  
//   String messageType = '';
//   String lastMessage = '';
//   String messageStatus = MessageStatus.none.name;

//   // Determine the message type and last message string
//   switch (message.messageType) {
//     case MessageType.audio:
//       messageType = 'audio';
//       lastMessage = '🎧Audio';
//       break;
//     case MessageType.contact:
//       messageType = 'contact';
//       lastMessage = '📞Contact';
//       break;
//     case MessageType.document:
//       messageType = 'document';
//       lastMessage = '📄Doc';
//       break;
//     case MessageType.photo:
//       messageType = 'photo';
//       lastMessage = '📷Photo';
//       break;
//     case MessageType.video:
//       messageType = 'video';
//       lastMessage = '🎥Video';
//       break;
//     case MessageType.location:
//       messageType = 'location';
//       lastMessage = '📌Location';
//       break;
//     default:
//       lastMessage = message.message ?? '';
//       messageType = 'text';
//   }

//   // Fetch receiver data
//   final receiverSnapshot = await FirebaseFirestore.instance
//       .collection(usersCollection)
//       .doc(chatModel.receiverID)
//       .get();
  
//   if (receiverSnapshot.exists) {
//     final receiverData = UserModel.fromJson(map: receiverSnapshot.data()!);

//     bool isChatOpen = await FirebaseFirestore.instance
//         .collection(usersCollection)
//         .doc(chatModel.receiverID)
//         .collection(chatsCollection)
//         .doc(chatModel.chatID)
//         .get()
//         .then((doc) => doc['isChatOpen'] ?? false);

//     if (receiverData.userNetworkStatus! && isChatOpen) {
//       messageStatus = MessageStatus.read.name;
//     } else if (receiverData.userNetworkStatus! && !isChatOpen) {
//       messageStatus = MessageStatus.delivered.name;
//     } else if (!receiverData.userNetworkStatus!) {
//       messageStatus = MessageStatus.sent.name;
//     }

//     // Update all messages in the chat
//     final messagesSnapshot = await FirebaseFirestore.instance
//         .collection(usersCollection)
//         .doc(chatModel.receiverID)
//         .collection(chatsCollection)
//         .doc(chatModel.chatID)
//         .collection(messagesCollection)
//         .get();

//     if (messagesSnapshot.docs.isNotEmpty) {
//       final batch = FirebaseFirestore.instance.batch();

//       for (final doc in messagesSnapshot.docs) {
//         batch.update(doc.reference, {
//           dbMessageStatus: messageStatus,
//         });
//       }

//       await batch.commit();
//     }

//     // Update sender's chat document
//     await FirebaseFirestore.instance
//         .collection(usersCollection)
//         .doc(chatModel.senderID)
//         .collection(chatsCollection)
//         .doc(chatModel.chatID)
//         .update({
//       chatLastMessageTime: message.messageTime,
//       lastChatType: messageType,
//       chatLastMessage: lastMessage,
//       lastChatStatus: messageStatus,
//       isIncoming: message.senderID == chatModel.receiverID,
//     });

//     // Update receiver's chat document
//     await FirebaseFirestore.instance
//         .collection(usersCollection)
//         .doc(chatModel.receiverID)
//         .collection(chatsCollection)
//         .doc(chatModel.chatID)
//         .update({
//       chatLastMessageTime: message.messageTime,
//       lastChatType: messageType,
//       chatLastMessage: lastMessage,
//       lastChatStatus: messageStatus,
//       isIncoming: message.senderID != chatModel.receiverID,
//     });
//   } else {
//     throw Exception("Receiver user data not found");
//   }
// }


  Stream<List<ChatModel>> getAllChatsFromDB() {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
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
      log("Status error: ${e.toString()}");
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
          .orderBy(dbMessageSendTime, descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromJson(map: doc.data()))
              .toList());
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 186: ${e.message}");
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
      log("From Chat Data: 208: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  void deleteOneChat({required ChatModel chatModel}) async {
    try {
      await firestore
          .collection(usersCollection)
          .doc(chatModel.senderID)
          .collection(chatsCollection)
          .doc(chatModel.chatID)
          .delete();
    } on FirebaseAuthException catch (e) {
      log("From Chat Data: 220: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<String> saveUserFileToDataBaseStorage({
    required String ref,
    required File file,
  }) async {
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } on FirebaseAuthException catch (e) {
      log(
        'Firebase Auth exception: $e',
      );
      throw Exception("Error while saving file to storage: $e");
    } catch (e, stackTrace) {
      log('Error while saving file to storage: $e', stackTrace: stackTrace);
      throw Exception("Error while saving file to storage: $e");
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
      log("From Chat Data: 262: ${e.message}");
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
      log("From Chat Data: 286: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }
}
