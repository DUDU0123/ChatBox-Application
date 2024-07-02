import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chatbox/features/data/data_sources/chat_data/chat_data.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/domain/repositories/chat_repo/chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  final ChatData chatData;
  final FirebaseAuth firebaseAuth;
  ChatRepoImpl({
    required this.chatData,
    required this.firebaseAuth,
  });
  @override
  Future<void> createNewChat({
    required ContactModel contactModel,
  }) async {
    if (firebaseAuth.currentUser != null &&
        contactModel.chatBoxUserId != null) {
      final isChatExists = await chatData.checkIfChatExistAlready(
        firebaseAuth.currentUser!.uid,
        contactModel.chatBoxUserId!,
      );
      if (!isChatExists) {
        await chatData.createANewChat(contactModel: contactModel);
      } else {
        return;
      }
    }
  }

  @override
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    await chatData.deleteMessageInAChat(chatId: chatId, messageId: messageId);
  }

  @override
  Future<void> editMessage({
    required String chatId,
    required String messageId,
    required MessageModel updatedMessage,
  }) async {
    await chatData.editMessageInAChat(
      chatId: chatId,
      messageId: messageId,
      updatedData: updatedMessage,
    );
  }

  @override
  Stream<List<ChatModel>> getAllChats() {
    return chatData.getAllChatsFromDB();
  }

  @override
  Stream<List<MessageModel>> getAllMessages({
    required String chatId,
  }) {
    return chatData.getAllMessagesFromDB(chatId: chatId);
  }

  @override
  Future<MessageModel> getOneMessage({
    required String chatId,
    required String messageId,
  }) async {
    return await chatData.getOneMessageFromDB(
        chatId: chatId, messageId: messageId);
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
  }) async {
    await chatData.sendMessageToAChat(chatId: chatId, message: message);
  }
}
