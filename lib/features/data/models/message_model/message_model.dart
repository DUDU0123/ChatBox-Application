import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/domain/entities/message_entity/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    super.messageId,
    super.senderID,
    super.receiverID,
    super.messageContent,
    super.messageTime,
    super.messageStatus,
    super.messageType,
    super.attachmentsWithMessage,
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
      messageContent: map[dbMessageContent],
      messageType: MessageType.values.byName(map[dbMessageType]),
      messageStatus: MessageStatus.values.byName(map[dbMessageStatus]),
      messageTime: map[dbMessageSendTime],
      attachmentsWithMessage: map[dbAttachmentsWithMessage],
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
      dbMessageContent: messageContent,
      dbMessageType: messageType?.name,
      dbMessageStatus: messageStatus?.name,
      dbMessageSendTime: messageTime,
      dbAttachmentsWithMessage: attachmentsWithMessage,
      dbIsMessageEdited: isEditedMessage,
      dbIsMessageDeleted: isDeletedMessage,
      dbIsMessageStarred: isStarredMessage,
      dbIsMessagePinned: isPinnedMessage,
    };
  }
}
