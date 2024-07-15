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
              map: event.data()??{},
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


  Future<void> sendMessageToAChat(
      {required String? chatId, required MessageModel message,required String receiverId,
  required String receiverContactName,}) async {
    try {
     final String?  currentUserId = firebaseAuth.currentUser?.uid;
     if (currentUserId==null) {
       return;
     }
     final isChatExists = await checkIfChatExistAlready(currentUserId, receiverId);
     if (!isChatExists && chatId==null) {
       await createANewChat(receiverId: receiverId, receiverContactName: receiverContactName);
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








  static void updateChatMessageDataOfUser(
      {required ChatModel? chatModel, required MessageModel message}) {
    if (chatModel?.senderID == null || chatModel?.receiverID == null) {
      return;
    }
    String messageType = '';
    String lastMessage = '';
    String messageStatus = '';
    // final Stream<UserModel?> receiverDataStream =
    //     UserData.getOneUserDataFromDataBaseAsStream(
    //         userId: chatModel.receiverID!);
    // final Stream<UserModel?> senderDataStream =
    //     UserData.getOneUserDataFromDataBaseAsStream(
    //         userId: chatModel.senderID!);
    final Stream<UserModel?> receiverDataStream =
        UserData.getOneUserDataFromDataBaseAsStream(
            userId: message.receiverID!);
    final Stream<UserModel?> senderDataStream =
        UserData.getOneUserDataFromDataBaseAsStream(
            userId: message.senderID!);
    receiverDataStream.listen((UserModel? data) async {
      if (data != null) {
        switch (message.messageStatus) {
          case MessageStatus.delivered:
            messageStatus = 'delivered';
            break;
          case MessageStatus.read:
            messageStatus = 'read';
            break;
          case MessageStatus.sent:
            messageStatus = 'sent';
            break;
          case MessageStatus.none:
            messageStatus = 'none';
            break;
          default:
        }
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
            lastMessage = message.message??'';
            messageType = 'text';
        }
        await fireStore
            .collection(usersCollection)
            .doc(chatModel?.senderID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .update({
          chatLastMessageTime: message.messageTime,
          lastChatType: messageType,
          chatLastMessage: lastMessage,
          lastChatStatus: messageStatus,
          isIncoming: message.senderID == chatModel?.receiverID,
        });
      } else {
        throw Exception("User data is null");
      }
    });

    senderDataStream.listen((UserModel? data) async {
      if (data != null) {
        await fireStore
            .collection(usersCollection)
            .doc(chatModel?.receiverID)
            .collection(chatsCollection)
            .doc(chatModel?.chatID)
            .update({
          chatLastMessageTime: message.messageTime,
          lastChatType: messageType,
          chatLastMessage: lastMessage,
          lastChatStatus: messageStatus,
          isIncoming: message.senderID != chatModel?.receiverID,
        });
      } else {
        throw Exception("User data is null");
      }
    });
  }

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
