import 'dart:io';

import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';

abstract class MessageRepo {
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  });

  Future<void> editMessage({
    required String chatId,
    required String messageId,
    required MessageModel updatedMessage,
  });

  Stream<List<MessageModel>> getAllMessages({
    String? chatId,
     GroupModel? groupModel,
    required bool isGroup,
  });

  Stream<List<MessageModel>>? getAllMessageOfAGroupChat(
      {required String groupID});

  Future<MessageModel> getOneMessage({
    required String chatId,
    required String messageId,
  });
  Future<void> sendMessage({
    required String? chatId,
    required MessageModel message,
    required String receiverId,
    required String receiverContactName,
  });
  Future<bool> sendMessageToAGroupChat({
    required groupID,
    required MessageModel message,
  });
  Future<String> sendAssetMessage({String? chatID, String? groupID, required File file});
}