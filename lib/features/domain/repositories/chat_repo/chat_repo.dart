import 'package:chatbox/features/data/models/chat_model/chat_model.dart';

abstract class ChatRepo{
  createAChat({required ChatModel chatModel});
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
  


}