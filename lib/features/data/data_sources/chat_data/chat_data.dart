import 'dart:developer';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';

class ChatData {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ChatData({
    required this.firestore,
    required this.firebaseAuth,
  });
  // check if chat exists or not
  Future<bool> checkIfChatExistAlready(
      String currentUserId, String contactId) async {
    try {
      String chatId =
          CommonDBFunctions.generateChatId(currentUserId: currentUserId, receiverId: contactId);
      DocumentSnapshot chatSnapshot = await firestore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(chatsCollection)
          .doc(chatId)
          .get();
      return chatSnapshot.exists;
    } on FirebaseException catch (e) {
      log("From Chat Data: 47: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }
  // create a new new chat if it is not exists
  Future<void> createANewChat({
    required String receiverId,
    required String receiverContactName,
  }) async {
    try {
      String currentUserId = firebaseAuth.currentUser!.uid;
      String chatId = CommonDBFunctions.generateChatId(
        currentUserId: currentUserId,
        receiverId: receiverId,
      );

      final Stream<UserModel?> receiverDataStream =
          CommonDBFunctions.getOneUserDataFromDataBaseAsStream(userId: receiverId);
      final Stream<UserModel?> currentUserDataStream =
          CommonDBFunctions.getOneUserDataFromDataBaseAsStream(userId: currentUserId);
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
    } on FirebaseException catch (e) {
      log("Firebase Auth exception: ${e.message}");
      throw Exception("Error while creating chat: ${e.message}");
    } catch (e, stackTrace) {
      log("Error while creating chat: $e", stackTrace: stackTrace);
      throw Exception("Error while creating chat: $e");
    }
  }

  // read all chat doc of a particular user
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
    } on FirebaseException catch (e) {
      log("From Chat Data: 107: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("Status error: ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // method for deleting a chat
  void deleteOneChat({required ChatModel chatModel}) async {
    try {
      await CommonDBFunctions.deleteAllMessagesOfAChatInDB(chatModel: chatModel);
      await firestore
          .collection(usersCollection)
          .doc(chatModel.senderID)
          .collection(chatsCollection)
          .doc(chatModel.chatID)
          .delete();
    } on FirebaseException catch (e) {
      log("From Chat Data: 220: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }


  // Future<void> sendMessageToAChat({
  //   required String? chatId,
  //   required MessageModel message,
  //   required String receiverId,
  //   required String receiverContactName,
  // }) async {
  //   try {
  //     final String? currentUserId = firebaseAuth.currentUser?.uid;
  //     if (currentUserId == null) {
  //       return;
  //     }
  //     if (message.senderID == message.receiverID) {
  //       await firestore
  //           .collection(usersCollection)
  //           .doc(message.senderID)
  //           .collection(chatsCollection)
  //           .doc(chatId)
  //           .collection(messagesCollection)
  //           .doc(message.messageId)
  //           .set(message.toJson());
  //     } else {
  //       await firestore
  //           .collection(usersCollection)
  //           .doc(message.senderID)
  //           .collection(chatsCollection)
  //           .doc(chatId)
  //           .collection(messagesCollection)
  //           .doc(message.messageId)
  //           .set(message.toJson());
  //       await firestore
  //           .collection(usersCollection)
  //           .doc(message.receiverID)
  //           .collection(chatsCollection)
  //           .doc(chatId)
  //           .collection(messagesCollection)
  //           .doc(message.messageId)
  //           .set(message.toJson());
  //     }
  //   } on FirebaseException catch (e) {
  //     log("From Chat Data: 241: ${e.message}");
  //     throw Exception(e.message);
  //   } catch (e) {
  //     log(e.toString());
  //     throw Exception(e.toString());
  //   }
  // }

  // Future<String> sendAssetMessage({
  //   required String chatID,
  //   required File file,
  // }) async {
  //   try {
  //     final assetUrl = await CommonDBFunctions.saveUserFileToDataBaseStorage(
  //         ref: "$chatAssetFolder$chatID/${DateTime.now()}", file: file);
  //     return assetUrl;
  //   } on FirebaseException catch (e) {
  //     log("Photo send error chat data: ${e.message}");
  //     throw Exception(e.message);
  //   } catch (e) {
  //     log(e.toString());
  //     throw Exception(e.toString());
  //   }
  // }

  

  // static void updateChatMessageDataOfUser({
  //   ChatModel? chatModel,
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

  //   // Listen to receiver's network status and chat state
  //   FirebaseFirestore.instance
  //       .collection(usersCollection)
  //       .doc(chatModel.receiverID)
  //       .snapshots()
  //       .listen((receiverSnapshot) async {
  //     if (receiverSnapshot.exists) {
  //       final receiverData = receiverSnapshot.data();
  //       bool userNetworkStatus = receiverData![userDbNetworkStatus] ?? false;

  //       bool isChatOpen = await FirebaseFirestore.instance
  //           .collection(usersCollection)
  //           .doc(chatModel.receiverID)
  //           .collection(chatsCollection)
  //           .doc(chatModel.chatID)
  //           .get()
  //           .then((doc) => doc[isUserChatOpen] ?? false);
  //       log("Is chat open: $isChatOpen");

  //       // Get the current message status
  //       String currentMessageStatus = await FirebaseFirestore.instance
  //           .collection(usersCollection)
  //           .doc(chatModel.senderID)
  //           .collection(chatsCollection)
  //           .doc(chatModel.chatID)
  //           .collection(messagesCollection)
  //           .doc(message.messageId)
  //           .get()
  //           .then((doc) => doc[dbMessageStatus] ?? MessageStatus.none.name);

  //       // Only update the status if it's not already 'read'
  //       if (currentMessageStatus != MessageStatus.read.name) {
  //         if (userNetworkStatus && isChatOpen) {
  //           messageStatus = MessageStatus.read.name;
  //         } else if (userNetworkStatus && !isChatOpen) {
  //           messageStatus = MessageStatus.delivered.name;
  //         } else if (!userNetworkStatus) {
  //           messageStatus = MessageStatus.sent.name;
  //         }
  //       } else {
  //         messageStatus = MessageStatus.read.name;
  //       }

  //       // getting the messages collection of sender chat
  //       final senderMessagesSnapshot = await FirebaseFirestore.instance
  //           .collection(usersCollection)
  //           .doc(chatModel.senderID)
  //           .collection(chatsCollection)
  //           .doc(chatModel.chatID)
  //           .collection(messagesCollection)
  //           .get();
  //       // getting the messages collection of receiver chat
  //       final receiverMessagesSnapshot = await FirebaseFirestore.instance
  //           .collection(usersCollection)
  //           .doc(chatModel.receiverID)
  //           .collection(chatsCollection)
  //           .doc(chatModel.chatID)
  //           .collection(messagesCollection)
  //           .get();

  //       // sender message snapshot editing message status
  //       if (senderMessagesSnapshot.docs.isNotEmpty) {
  //         final batch = FirebaseFirestore.instance.batch();

  //         for (final doc in senderMessagesSnapshot.docs) {
  //           String currentStatus =
  //               doc.data()[dbMessageStatus] ?? MessageStatus.none.name;
  //           if (currentStatus != MessageStatus.read.name) {
  //             batch.update(doc.reference, {
  //               dbMessageStatus: messageStatus,
  //             });
  //           }
  //         }

  //         await batch.commit();
  //       } else {
  //         log("No messages to update for sender");
  //       }
  //       // receiver message snapshot editing message status
  //       if (receiverMessagesSnapshot.docs.isNotEmpty) {
  //         final batch = FirebaseFirestore.instance.batch();

  //         for (final doc in receiverMessagesSnapshot.docs) {
  //           String currentStatus =
  //               doc.data()[dbMessageStatus] ?? MessageStatus.none.name;
  //           if (currentStatus != MessageStatus.read.name) {
  //             batch.update(doc.reference, {
  //               dbMessageStatus: messageStatus,
  //             });
  //           }
  //         }

  //         await batch.commit();
  //       } else {
  //         log("No messages to update for receiver");
  //       }

  //       // Update sender's chat document
  //       await FirebaseFirestore.instance
  //           .collection(usersCollection)
  //           .doc(chatModel.senderID)
  //           .collection(chatsCollection)
  //           .doc(chatModel.chatID)
  //           .update({
  //         chatLastMessageTime: message.messageTime,
  //         lastChatType: messageType,
  //         chatLastMessage: lastMessage,
  //         lastChatStatus: messageStatus,
  //         isIncoming: message.senderID == chatModel.receiverID,
  //       });

  //       // Update receiver's chat document
  //       await FirebaseFirestore.instance
  //           .collection(usersCollection)
  //           .doc(chatModel.receiverID)
  //           .collection(chatsCollection)
  //           .doc(chatModel.chatID)
  //           .update({
  //         chatLastMessageTime: message.messageTime,
  //         lastChatType: messageType,
  //         chatLastMessage: lastMessage,
  //         lastChatStatus: messageStatus,
  //         isIncoming: message.senderID != chatModel.receiverID,
  //       });

  //       await FirebaseFirestore.instance
  //           .collection(usersCollection)
  //           .doc(chatModel.receiverID)
  //           .collection(chatsCollection)
  //           .doc(chatModel.chatID)
  //           .collection(messagesCollection)
  //           .doc(message.messageId)
  //           .update({
  //         dbMessageStatus: messageStatus,
  //       });
  //     } else {
  //       log("Receiver snapshot does not exist");
  //     }
  //   });
  // }

  

  // Stream<List<MessageModel>> getAllMessagesFromDB({required String chatId}) {
  //   try {
  //     String currentUserId = firebaseAuth.currentUser!.uid;
  //     return firestore
  //         .collection(usersCollection)
  //         .doc(currentUserId)
  //         .collection(chatsCollection)
  //         .doc(chatId)
  //         .collection(messagesCollection)
  //         .orderBy(dbMessageSendTime, descending: false)
  //         .snapshots()
  //         .map((snapshot) => snapshot.docs
  //             .map((doc) => MessageModel.fromJson(map: doc.data()))
  //             .toList());
  //   } on FirebaseException catch (e) {
  //     log("From Chat Data: 186: ${e.message}");
  //     throw Exception(e.message);
  //   } catch (e) {
  //     log(e.toString());
  //     throw Exception(e.toString());
  //   }
  // }

  // Future<MessageModel> getOneMessageFromDB(
  //     {required String chatId, required String messageId}) async {
  //   try {
  //     String currentUserId = firebaseAuth.currentUser!.uid;
  //     DocumentSnapshot doc = await firestore
  //         .collection(usersCollection)
  //         .doc(currentUserId)
  //         .collection(chatsCollection)
  //         .doc(chatId)
  //         .collection(messagesCollection)
  //         .doc(messageId)
  //         .get();
  //     return MessageModel.fromJson(map: doc.data() as Map<String, dynamic>);
  //   } on FirebaseException catch (e) {
  //     log("From Chat Data: 208: ${e.message}");
  //     throw Exception(e.message);
  //   } catch (e) {
  //     log(e.toString());
  //     throw Exception(e.toString());
  //   }
  // }


  // Future<void> deleteMessageInAChat(
  //     {required String chatId, required String messageId}) async {
  //   try {
  //     String currentUserId = firebaseAuth.currentUser!.uid;
  //     await firestore
  //         .collection(usersCollection)
  //         .doc(currentUserId)
  //         .collection(chatsCollection)
  //         .doc(chatId)
  //         .collection(messagesCollection)
  //         .doc(messageId)
  //         .delete();
  //   } on FirebaseException catch (e) {
  //     log("From Chat Data: 262: ${e.message}");
  //     throw Exception(e.message);
  //   } catch (e) {
  //     log(e.toString());
  //     throw Exception(e.toString());
  //   }
  // }

  // Future<void> editMessageInAChat({
  //   required String chatId,
  //   required String messageId,
  //   required MessageModel updatedData,
  // }) async {
  //   try {
  //     String currentUserId = firebaseAuth.currentUser!.uid;
  //     await firestore
  //         .collection(usersCollection)
  //         .doc(currentUserId)
  //         .collection(chatsCollection)
  //         .doc(chatId)
  //         .collection(messagesCollection)
  //         .doc(messageId)
  //         .update(updatedData.toJson());
  //   } on FirebaseException catch (e) {
  //     log("From Chat Data: 286: ${e.message}");
  //     throw Exception(e.message);
  //   } catch (e) {
  //     log(e.toString());
  //     throw Exception(e.toString());
  //   }
  // }
}
