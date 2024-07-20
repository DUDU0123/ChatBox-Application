import 'dart:io';

import 'package:chatbox/features/data/data_sources/message_data/message_data.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/domain/repositories/message_repo/message_repo.dart';

class MessageRepoImpl extends MessageRepo {
  final MessageData messageData;
  MessageRepoImpl({
    required this.messageData,
  });
  @override
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    await messageData.deleteMessageInAChat(
        chatId: chatId, messageId: messageId);
  }

  @override
  Future<void> editMessage({
    required String chatId,
    required String messageId,
    required MessageModel updatedMessage,
  }) async {
    await messageData.editMessageInAChat(
      chatId: chatId,
      messageId: messageId,
      updatedData: updatedMessage,
    );
  }

  @override
  Stream<List<MessageModel>> getAllMessages({
    required String chatId,
    GroupModel? groupModel,
    required bool isGroup,
  }) {
    return messageData.getAllMessagesFromDB(
      chatId: chatId,
      isGroup: isGroup,
      groupModel: groupModel,
    );
  }

  @override
  Future<MessageModel> getOneMessage({
    required String chatId,
    required String messageId,
  }) async {
    return await messageData.getOneMessageFromDB(
        chatId: chatId, messageId: messageId);
  }

  @override
  Future<void> sendMessage({
    required String? chatId,
    required MessageModel message,
    required String receiverId,
    required String receiverContactName,
  }) async {
    await messageData.sendMessageToAChat(
      chatId: chatId,
      message: message,
      receiverContactName: receiverContactName,
      receiverId: receiverId,
    );
  }

  @override
  Future<String> sendAssetMessage(
      {required String chatID, required File file}) {
    return messageData.sendAssetMessage(
      chatID: chatID,
      file: file,
    );
  }

  @override
  Future<bool> sendMessageToAGroupChat(
      {required groupID, required MessageModel message}) async {
    return await messageData.sendMessageToAGroup(
      groupID: groupID,
      message: message,
    );
  }

  @override
  Stream<List<MessageModel>>? getAllMessageOfAGroupChat(
      {required String groupID}) {
    return messageData.getAllMessageOfAGroupChat(
      groupID: groupID,
    );
  }
}
