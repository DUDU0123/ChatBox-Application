import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';

abstract class ChatRepo {
  // if chat not exists create a chat
  // else nothing to do;
  /*ChatModel(
      chatID: currentUserIDreceiverID
     lastMessage: '',
     lastMessageTime '',
     notificationCount: '',
     receiverID: recieverID,
     recieverProfileImage: '',
     isMuted: false;
     senderID: currentUserID,
     );*/
  Future<void> createNewChat({
    required ContactModel contactModel,
  });
  Stream<List<ChatModel>> getAllChats();
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
