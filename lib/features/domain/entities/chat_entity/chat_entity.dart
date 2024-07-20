import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/domain/entities/message_entity/message_entity.dart';
import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String? chatID;
  final String? receiverID;
  
  final String? receiverName;
  final String? receiverProfileImage;
  
  final List<MessageAttachmentModel>? attachmentsWithMessage;
  final bool? isMuted;
  final MessageStatus? lastMessageStatus;
  final String? lastMessage;
  final String? lastMessageTime;
  final MessageType? lastMessageType;
  final int? notificationCount;
  final bool? isIncomingMessage;
  final bool? isChatOpen;
  final String? senderID;
  final bool? isGroup;
  const ChatEntity({
    this.receiverName,
    this.attachmentsWithMessage,
    this.chatID,
    this.receiverID,
    this.lastMessage,
    this.lastMessageTime,
    this.receiverProfileImage,
    this.isMuted,
    this.notificationCount,
    this.senderID,
    this.lastMessageStatus,
    this.lastMessageType,
    this.isIncomingMessage,
    this.isGroup,
    this.isChatOpen,
  });

  @override
  List<Object?> get props {
    return [
      chatID,
      receiverID,
      lastMessage,
      lastMessageTime,
      receiverProfileImage,
      isMuted,
      notificationCount,
      senderID,
      lastMessageStatus,
      lastMessageType,
      receiverName,
      attachmentsWithMessage,
      isIncomingMessage,
      isChatOpen,
      isGroup,
    ];
  }
}
