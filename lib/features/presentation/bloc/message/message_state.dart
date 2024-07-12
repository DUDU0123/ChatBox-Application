part of 'message_bloc.dart';
class MessageState extends Equatable {
  final bool? isTyped;
  final bool? isAttachmentListOpened;
  final bool? isVideoPlaying;
  final Duration audioPosition;
  final Duration audioDuration;

  const MessageState({
    this.isTyped,
    this.isAttachmentListOpened,
    this.isVideoPlaying = false,
    this.audioPosition = Duration.zero,
    this.audioDuration = Duration.zero,
  });

  MessageState copyWith({
    bool? isTyped,
    bool? isAttachmentListOpened,
    bool? isVideoPlaying,
    Duration? audioPosition,
    Duration? audioDuration,
  }) {
    return MessageState(
      isTyped: isTyped ?? this.isTyped,
      isAttachmentListOpened: isAttachmentListOpened ?? this.isAttachmentListOpened,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
      audioPosition: audioPosition ?? this.audioPosition,
      audioDuration: audioDuration ?? this.audioDuration,
    );
  }

  @override
  List<Object> get props => [isTyped ?? false, isAttachmentListOpened ?? false, isVideoPlaying ?? false, audioPosition, audioDuration];
}


class MessageInitial extends MessageState {
   const MessageInitial();
}

class MessageLoadingState extends MessageState {}

class MessageSucessState extends MessageState {
  final Stream<List<MessageModel>> messages;
   final MessageModel? messageModel;
   const MessageSucessState({
    required this.messages,
    this.messageModel,
  });
  @override
  List<Object> get props => [messages,];
}

class MessageErrorState extends MessageState {
  final String message;
   const MessageErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message,];
}
class AssetMessageState extends MessageState {
  final MessageModel messageModel;
 const AssetMessageState({
    required this.messageModel,
  });
  @override
  List<Object> get props => [messageModel,];
}

class CurrentLocationState extends MessageState {
  final LatLng currentLocation;
  final double latitude;
  final double longitude;
  const CurrentLocationState({
    required this.currentLocation,
    required this.latitude,
    required this.longitude,
  });
  @override
  List<Object> get props => [currentLocation,];
}
