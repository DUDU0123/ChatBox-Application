import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/domain/entities/chat_entity/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    super.chatID,
    super.senderID,
    super.receiverID,
    super.lastMessage,
    super.lastMessageTime,
    super.lastMessageStatus,
    super.lastMessageType,
    super.notificationCount,
    super.recieverProfileImage,
    super.isMuted,
  });

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    return ChatModel(
      chatID: map[chatId],
      receiverID: map[receiverId],
      senderID: map[senderId],
      recieverProfileImage: map[receiverProfilePhoto],
      lastMessageTime: map[chatLastMessageTime],
      lastMessage: map[chatLastMessage],
      isMuted: map[chatMuted]??false,
      notificationCount: map[chatMessageNotificationCount],
      lastMessageStatus: MessageStatus.values.byName(map[lastChatStatus]),
      lastMessageType: MessageType.values.byName(map[lastChatType]),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      chatId: chatID,
      receiverId: receiverID,
      senderId: senderID,
      receiverProfilePhoto: recieverProfileImage,
      chatLastMessageTime: lastMessageTime,
      chatLastMessage: lastMessage,
      chatMuted: isMuted,
      chatMessageNotificationCount: notificationCount,
      lastChatType: lastMessageType,
      lastChatStatus: lastMessageStatus,
    };
  }
}
