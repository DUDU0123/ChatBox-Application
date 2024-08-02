import 'dart:io';

import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';

abstract class ChatRepo {
  Future<void> createNewChat({
    required String receiverId,
    required String recieverContactName,
  });
  Stream<List<ChatModel>> getAllChats();
  void deleteAChat({
    required ChatModel chatModel
  });
  Future<void> clearChatMethodInOneToOne({required String chatID});
  Future<bool> clearAllChatsInApp();
  // Future<MessageModel> getOneMessage({
  //   required String chatId,
  //   required String messageId,
  // });
  // Future<void> sendMessage({
  //   required String? chatId,
  //   required MessageModel message,
  //   required String receiverId,
  // required String receiverContactName,
  // });
  // Future<String> sendAssetMessage({
  //   required String chatID,
  //   required File file,
  // });
  // Future<void> deleteMessage({
  //   required String chatId,
  //   required String messageId,
  // });
  // Future<void> editMessage({
  //   required String chatId,
  //   required String messageId,
  //   required MessageModel updatedMessage,
  // });
}
