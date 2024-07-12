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
  final ChatModel chatModel;
  final File? file;
  final MessageModel message;
  const MessageSentEvent({
    required this.chatModel,
    this.file,
    required this.message,
  });
  @override
  List<Object> get props => [
        chatModel,
        message,
      ];
}

class PhotoMessageSendEvent extends MessageEvent {
  final ImageSource imageSource;
  final ChatModel chatModel;
  const PhotoMessageSendEvent({
    required this.imageSource,
    required this.chatModel,
  });
  @override
  List<Object> get props => [
        imageSource,
        chatModel,
      ];
}

class VideoMessageSendEvent extends MessageEvent {
  final ImageSource imageSource;
  final ChatModel chatModel;
  const VideoMessageSendEvent({
    required this.imageSource,
    required this.chatModel,
  });
  @override
  List<Object> get props => [
        imageSource,
        chatModel,
      ];
}

class GetOneMessageEvent extends MessageEvent {
  @override
  List<Object> get props => [];
}

class GetAllMessageEvent extends MessageEvent {
  final String chatId;
  const GetAllMessageEvent({
    required this.chatId,
  });
  @override
  List<Object> get props => [
        chatId,
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
  const ContactMessageSendEvent({
    required this.contactListToSend,
    required this.chatModel,
  });
  @override
  List<Object> get props => [
        contactListToSend,
      ];
}

class OpenDeviceFileAndSaveToDbEvent extends MessageEvent {
  final ChatModel chatModel;
  final MessageType messageType;
  const OpenDeviceFileAndSaveToDbEvent({
    required this.chatModel,
    required this.messageType,
  });
  @override
  List<Object> get props => [
        chatModel,messageType,
      ];
}

class AudioRecordToggleEvent extends MessageEvent {
  final ChatModel chatModel;
  final FlutterSoundRecorder recorder;
  const AudioRecordToggleEvent({
    required this.chatModel,
    required this.recorder,
  });
  @override
  List<Object> get props => [
        chatModel,
        recorder,
      ];
}

class AudioMessageSendEvent extends MessageEvent {
  final ChatModel chatModel;
  final File audioFile;
  const AudioMessageSendEvent({
    required this.chatModel,
    required this.audioFile,
  });
  @override
  List<Object> get props => [
        chatModel,
      ];
}

class AudioPlayerPositionChangedEvent extends MessageEvent {
  final Duration position;
  const AudioPlayerPositionChangedEvent(this.position);

  @override
  List<Object> get props => [position];
}

class AudioPlayerDurationChangedEvent extends MessageEvent {
  final Duration duration;
  const AudioPlayerDurationChangedEvent(this.duration);

  @override
  List<Object> get props => [duration];
}
class LocationPickEvent extends MessageEvent{}
class LocationMessageSendEvent extends MessageEvent {
  final ChatModel chatModel;
  final String location;
  const LocationMessageSendEvent({
    required this.chatModel,
    required this.location,
  });
  @override
  List<Object> get props => [chatModel];
}
