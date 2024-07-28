import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatbox/features/data/data_sources/chat_data/chat_data.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
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
    required String receiverId,
    required String recieverContactName,
  }) async {
    if (firebaseAuth.currentUser != null) {
      final isChatExists = await chatData.checkIfChatExistAlready(
        firebaseAuth.currentUser!.uid,
        receiverId,
      );
      if (!isChatExists) {
        await chatData.createANewChat(
          receiverId: receiverId,
          receiverContactName: recieverContactName,
        );
      } else {
        return;
      }
    }
  }

  @override
  Stream<List<ChatModel>> getAllChats() {
    return chatData.getAllChatsFromDB();
  }

  @override
  void deleteAChat({
    required ChatModel chatModel,
  }) async {
    chatData.deleteOneChat(
      chatModel: chatModel,
    );
  }
  
  @override
  Future<void> clearChatMethodInOneToOne({required String chatID}) async{
    await chatData.clearChatInOneToOne(chatID: chatID);
  }
}
