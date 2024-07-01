import 'package:equatable/equatable.dart';
import 'package:chatbox/core/enums/enums.dart';

class MessageEntity extends Equatable {
  final String? messageId;
  final String? senderID;
  final String? receiverID;
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
    this.receiverID,
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
      receiverID,
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

class MessageAttachmentModel extends Equatable {
  final String? attachmentUrl;
  final MessageType messageType;
  const MessageAttachmentModel({
    this.attachmentUrl,
    required this.messageType,
  });

  @override
  List<Object?> get props => [attachmentUrl, messageType];
}
