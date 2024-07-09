import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/domain/entities/message_entity/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    super.messageId,
    super.senderID,
    super.receiverID,
    super.message,
    super.messageTime,
    super.messageStatus,
    super.messageType,
    super.isEditedMessage,
    super.isDeletedMessage,
    super.isStarredMessage,
    super.isPinnedMessage,
  });

  factory MessageModel.fromJson({
    required Map<String, dynamic> map,
  }) {
    return MessageModel(
      messageId: map[dbMessageID],
      senderID: map[dbMessageSenderID],
      receiverID: map[dbMessageRecieverID],
      message: map[dbMessageContent],
      messageType: MessageType.values.byName(map[dbMessageType]),
      messageStatus: MessageStatus.values.byName(map[dbMessageStatus]),
      messageTime: map[dbMessageSendTime],
      isEditedMessage: map[dbIsMessageEdited],
      isDeletedMessage: map[dbIsMessageDeleted],
      isStarredMessage: map[dbIsMessageStarred],
      isPinnedMessage: map[dbIsMessagePinned],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      dbMessageID: messageId,
      dbMessageSenderID: senderID,
      dbMessageRecieverID: receiverID,
      dbMessageContent: message,
      dbMessageType: messageType?.name,
      dbMessageStatus: messageStatus?.name,
      dbMessageSendTime: messageTime,
      dbIsMessageEdited: isEditedMessage,
      dbIsMessageDeleted: isDeletedMessage,
      dbIsMessageStarred: isStarredMessage,
      dbIsMessagePinned: isPinnedMessage,
    };
  }

  MessageModel copyWith({
    String? messageId,
    String? senderID,
    String? receiverID,
    String? message,
    String? messageTime,
    MessageStatus? messageStatus,
    MessageType? messageType,
    bool? isEditedMessage,
    bool? isDeletedMessage,
    bool? isStarredMessage,
    bool? isPinnedMessage,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      senderID: senderID ?? this.senderID,
      receiverID: receiverID ?? this.receiverID,
      message: message ?? this.message,
      messageTime: messageTime ?? this.messageTime,
      messageStatus: messageStatus ?? this.messageStatus,
      messageType: messageType ?? this.messageType,
      isEditedMessage: isEditedMessage ?? this.isEditedMessage,
      isDeletedMessage: isDeletedMessage ?? this.isDeletedMessage,
      isStarredMessage: isStarredMessage ?? this.isStarredMessage,
      isPinnedMessage: isPinnedMessage ?? this.isPinnedMessage,
    );
  }
}
