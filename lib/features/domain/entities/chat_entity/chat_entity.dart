import 'package:chatbox/core/enums/enums.dart';
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String? chatID;
  final String? receiverID;
  final String? lastMessage;
  final String? lastMessageTime;
  final String? recieverProfileImage;
  final bool? isMuted;
  final MessageStatus? lastMessageStatus;
  final MessageType? lastMessageType;
  final int? notificationCount;
  final String? senderID;
  const ChatEntity({
    this.chatID,
    this.receiverID,
    this.lastMessage,
    this.lastMessageTime,
    this.recieverProfileImage,
    this.isMuted,
    this.notificationCount,
    this.senderID,
    this.lastMessageStatus,
    this.lastMessageType,
  });

  @override
  List<Object?> get props {
    return [
      chatID,
      receiverID,
      lastMessage,
      lastMessageTime,
      recieverProfileImage,
      isMuted,
      notificationCount,
      senderID,
      lastMessageStatus,
      lastMessageType,
    ];
  }
}
