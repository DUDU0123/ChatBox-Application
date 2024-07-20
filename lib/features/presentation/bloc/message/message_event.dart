part of 'message_bloc.dart';

sealed class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class MessageTypedEvent extends MessageEvent {
  final int textLength;
  const MessageTypedEvent({
    required this.textLength,
  });
  @override
  List<Object> get props => [
        textLength,
      ];
}

class AttachmentIconClickedEvent extends MessageEvent {
  @override
  List<Object> get props => [];
}

class MessageSentEvent extends MessageEvent {
  final ChatModel? chatModel;
  final String receiverID;
  final String currentUserId;
  final String receiverContactName;
  final File? file;
  final MessageModel message;
  final bool isGroup;
  final GroupModel? groupModel;
  const MessageSentEvent({
    required this.chatModel,
    required this.receiverID,
    required this.currentUserId,
    required this.receiverContactName,
    this.file,
    required this.message,
    required this.isGroup,
    this.groupModel,
  });
  @override
  List<Object> get props => [
        chatModel ?? const ChatModel(),
        message,
        file ?? File(''),
        currentUserId,
        receiverContactName,
        groupModel ?? const GroupModel(),
        isGroup,
      ];
}

class PhotoMessageSendEvent extends MessageEvent {
  final ImageSource imageSource;
  final ChatModel? chatModel;
  final String receiverID;
  final String receiverContactName;
  final bool isGroup;
  final GroupModel? groupModel;
  const PhotoMessageSendEvent({
    required this.imageSource,
     this.chatModel,
    required this.receiverID,
    required this.receiverContactName,
    required this.isGroup,
    this.groupModel,
  });
  @override
  List<Object> get props => [
        imageSource,
        chatModel??const ChatModel(),
        isGroup,
        groupModel ?? const GroupModel(),
      ];
}

class VideoMessageSendEvent extends MessageEvent {
  final ImageSource imageSource;
  final ChatModel chatModel;
  final String receiverID;
  final String receiverContactName;
  final bool isGroup;
  final GroupModel? groupModel;
  const VideoMessageSendEvent({
    required this.imageSource,
    required this.chatModel,
    required this.receiverID,
    required this.receiverContactName,
    required this.isGroup,
    this.groupModel,
  });
  @override
  List<Object> get props => [
        imageSource,
        chatModel,
        isGroup,
        groupModel ?? const GroupModel(),
      ];
}

class GetOneMessageEvent extends MessageEvent {
  @override
  List<Object> get props => [];
}

class GetAllMessageEvent extends MessageEvent {
  final String? chatId;
  final String currentUserId;
  final String receiverId;
  final bool? isGroup;
  final GroupModel? groupModel;
  const GetAllMessageEvent({
    required this.chatId,
    required this.currentUserId,
    required this.receiverId,
    this.isGroup,
    this.groupModel,
  });
  @override
  List<Object> get props => [
        chatId ?? currentUserId,
        receiverId,
        isGroup??false,
        groupModel ?? const GroupModel(),
      ];
}

class MessageDeleteEvent extends MessageEvent {
  @override
  List<Object> get props => [];
}

class MessageEditEvent extends MessageEvent {
  @override
  List<Object> get props => [];
}

class VideoMessagePlayEvent extends MessageEvent {
  @override
  List<Object> get props => [];
}

class VideoMessageCompleteEvent extends MessageEvent {
  @override
  List<Object> get props => [];
}

class VideoMessagePauseEvent extends MessageEvent {
  @override
  List<Object> get props => [];
}

class AssetMessageEvent extends MessageEvent {
  @override
  List<Object> get props => [];
}

class ContactMessageSendEvent extends MessageEvent {
  final List<ContactModel> contactListToSend;
  final ChatModel chatModel;
  final String receiverID;
  final String receiverContactName;
  final bool isGroup;
  final GroupModel? groupModel;
  const ContactMessageSendEvent({
    required this.contactListToSend,
    required this.chatModel,
    required this.receiverID,
    required this.receiverContactName,
    required this.isGroup,
    this.groupModel,
  });
  @override
  List<Object> get props => [
        contactListToSend,
        chatModel,
        groupModel ?? const GroupModel(),
        receiverContactName,
        isGroup,
        receiverID,
      ];
}

class OpenDeviceFileAndSaveToDbEvent extends MessageEvent {
  final ChatModel? chatModel;
  final MessageType messageType;
  final String receiverID;
  final bool isGroup;
  final GroupModel? groupModel;
  final String receiverContactName;
  const OpenDeviceFileAndSaveToDbEvent({
    this.chatModel,
    required this.messageType,
    required this.receiverID,
    required this.isGroup,
    this.groupModel,
    required this.receiverContactName,
  });
  @override
  List<Object> get props => [
        chatModel??const ChatModel(),
        messageType,
        receiverID,
        receiverContactName,
        groupModel ?? const GroupModel(),
        isGroup,
      ];
}

class AudioRecordToggleEvent extends MessageEvent {
  final ChatModel? chatModel;
  final FlutterSoundRecorder recorder;
  final String receiverID;
  final String receiverContactName;
  final bool isGroup;
  final GroupModel? groupModel;
  const AudioRecordToggleEvent({
    this.chatModel,
    required this.recorder,
    required this.receiverID,
    required this.receiverContactName,
    required this.isGroup,
    this.groupModel,
  });
  @override
  List<Object> get props => [
        chatModel ?? const ChatModel(),
        recorder,
        receiverContactName,
        receiverID,
        isGroup,
        groupModel ?? const GroupModel(),
      ];
}

class AudioMessageSendEvent extends MessageEvent {
  final ChatModel? chatModel;
  final File audioFile;
  final String receiverID;
  final String receiverContactName;
  final bool isGroup;
  final GroupModel? groupModel;
  const AudioMessageSendEvent({
    this.chatModel,
    required this.audioFile,
    required this.receiverID,
    required this.receiverContactName,
    required this.isGroup,
    this.groupModel,
  });
  @override
  List<Object> get props => [
        chatModel ?? const ChatModel(),
        audioFile,
        receiverContactName,
        receiverID,
        isGroup,
        groupModel ?? const GroupModel(),
      ];
}

class LocationPickEvent extends MessageEvent {}

class LocationMessageSendEvent extends MessageEvent {
  final ChatModel chatModel;
  final String location;
  final String receiverID;
  final String receiverContactName;
  final bool isGroup;
  final GroupModel? groupModel;
  const LocationMessageSendEvent({
    required this.chatModel,
    required this.location,
    required this.receiverID,
    required this.receiverContactName,
    required this.isGroup,
    this.groupModel,
  });
  @override
  List<Object> get props => [
        chatModel,
        location,
        receiverContactName,
        receiverID,
        isGroup,
        groupModel ?? const GroupModel(),
      ];
}

class ChatOpenedEvent extends MessageEvent {
  final ChatModel chatModel;
  const ChatOpenedEvent({
    required this.chatModel,
  });
  @override
  List<Object> get props => [chatModel];
}

class ChatClosedEvent extends MessageEvent {
  final ChatModel chatModel;
  const ChatClosedEvent({
    required this.chatModel,
  });
  @override
  List<Object> get props => [chatModel];
}

class AudioPlayerPositionChangedEvent extends MessageEvent {
  final String messageKey;
  final Duration position;

  const AudioPlayerPositionChangedEvent(this.messageKey, this.position);
  @override
  List<Object> get props => [messageKey, position];
}

class AudioPlayerDurationChangedEvent extends MessageEvent {
  final String messageKey;
  final Duration duration;

  const AudioPlayerDurationChangedEvent(this.messageKey, this.duration);
  @override
  List<Object> get props => [duration, messageKey];
}

class AudioPlayerPlayStateChangedEvent extends MessageEvent {
  final String messageKey;
  final bool isPlaying;

  const AudioPlayerPlayStateChangedEvent(this.messageKey, this.isPlaying);
  @override
  List<Object> get props => [isPlaying, messageKey];
}

class AudioPlayerCompletedEvent extends MessageEvent {
  final String messageKey;

  const AudioPlayerCompletedEvent(this.messageKey);
  @override
  List<Object> get props => [messageKey];
}

class MessageSelectedEvent extends MessageEvent {
  final MessageModel messageModel;
  const MessageSelectedEvent({
    required this.messageModel,
  });
  @override
  List<Object> get props => [
        messageModel,
      ];
}

class GetMessageDateEvent extends MessageEvent {
  final String currentMessageDate;
  const GetMessageDateEvent({
    required this.currentMessageDate,
  });
  @override
  List<Object> get props => [
        currentMessageDate,
      ];
}
