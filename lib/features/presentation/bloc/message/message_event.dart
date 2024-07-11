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

class AttachmentIconClickedEvent extends MessageEvent {}
class MessageSentEvent extends MessageEvent {
  final String chatId;
  final File? file;
  final MessageModel message;
 const MessageSentEvent({
    required this.chatId,
    this.file,
    required this.message,
  });
  @override
  List<Object> get props => [chatId,message,];
}

class PhotoMessageSendEvent extends MessageEvent {
  final ImageSource imageSource;
  final ChatModel chatModel;
  const PhotoMessageSendEvent({
    required this.imageSource,
    required this.chatModel,
  });
}
class VideoMessageSendEvent extends MessageEvent {
  final ImageSource imageSource;
  final ChatModel chatModel;
  const VideoMessageSendEvent({
    required this.imageSource,
    required this.chatModel,
  });
}
class GetOneMessageEvent extends MessageEvent{}
class GetAllMessageEvent extends MessageEvent {
  final String chatId;
  const GetAllMessageEvent({
    required this.chatId,
  });
}
class MessageDeleteEvent extends MessageEvent{}
class MessageEditEvent extends MessageEvent{}
class VideoMessagePlayEvent extends MessageEvent{}
class VideoMessageCompleteEvent extends MessageEvent {}
class VideoMessagePauseEvent extends MessageEvent {}
class AssetMessageEvent extends MessageEvent{}