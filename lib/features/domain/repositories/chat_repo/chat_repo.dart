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
  Stream<List<MessageModel>> getAllMessages({
    required String chatId,
  });
  Future<MessageModel> getOneMessage({
    required String chatId,
    required String messageId,
  });
  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
  });
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  });
  Future<void> editMessage({
    required String chatId,
    required String messageId,
    required MessageModel updatedMessage,
  });
}
