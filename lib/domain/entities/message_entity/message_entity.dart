import 'package:chatbox/core/enums/enums.dart';
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? messageId;
  final String? senderID;
  final String? recieverID;
  final String? messageContent;
  final String? messageTime;
  final MessageStatus? messageStatus;
  final MessageType? messageType;
  final List<MessageAttachmentModel>? attachmentsWithMessage;
  final bool? isEditedMessage;
  final bool? isDeletedMessage;
  final bool? isStarredMessage;
  final bool? isPinnedMessage;
  const MessageEntity({
    this.messageId,
    this.senderID,
    this.recieverID,
    this.messageContent,
    this.messageTime,
    this.messageStatus,
    this.messageType,
    this.attachmentsWithMessage,
    this.isEditedMessage,
    this.isDeletedMessage,
    this.isStarredMessage,
    this.isPinnedMessage,
  });

  @override
  List<Object?> get props {
    return [
      messageId,
      senderID,
      recieverID,
      messageContent,
      messageTime,
      messageStatus,
      messageType,
      attachmentsWithMessage,
      isEditedMessage,
      isDeletedMessage,
      isStarredMessage,
      isPinnedMessage,
    ];
  }
}

class MessageAttachmentModel {
  final String? attachmentUrl;
  final MessageType messageType;
  MessageAttachmentModel({
    this.attachmentUrl,
    required this.messageType,
  });
}
