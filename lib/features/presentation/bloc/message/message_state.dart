part of 'message_bloc.dart';
class MessageState extends Equatable{
  final bool? isTyped;
  final bool? isAttachmentListOpened;
  final bool? isVideoPlaying;
  final Stream<List<MessageModel>>? messages;
  final MessageModel? messagemodel;
  final bool? isRecording;
  final Map<String, Duration> audioPositions;
  final Map<String, Duration> audioDurations;
  final Map<String, bool> audioPlayingStates;

  const MessageState({
    this.audioPositions = const {},
    this.audioDurations = const {},
    this.audioPlayingStates = const {},
    this.isRecording = false,
    this.messages,
    this.isTyped,
    this.isAttachmentListOpened = false,
    this.isVideoPlaying = false,
    this.messagemodel,
  });

  MessageState copyWith({
    bool? isTyped,
    bool? isAttachmentListOpened,
    bool? isVideoPlaying,
    bool? isRecording,
    Map<String, Duration>? audioPositions,
    Map<String, Duration>? audioDurations,
    Map<String, bool>? audioPlayingStates,
    Stream<List<MessageModel>>? messages,
    MessageModel? messagemodel,
  }) {
    return MessageState(
      isTyped: isTyped ?? this.isTyped,
      isAttachmentListOpened:
          isAttachmentListOpened ?? this.isAttachmentListOpened,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
      audioPositions: audioPositions ?? this.audioPositions,
      audioDurations: audioDurations ?? this.audioDurations,
      audioPlayingStates: audioPlayingStates ?? this.audioPlayingStates,
      messages: messages ?? this.messages,
      messagemodel: messagemodel ?? this.messagemodel,
      isRecording: isRecording ?? this.isRecording,
    );
  }
  @override
  List<Object> get props => [
        isTyped ?? false,
        isAttachmentListOpened ?? false,
        isVideoPlaying ?? false,
        audioPositions,
        audioDurations,
        audioPlayingStates,
        messagemodel ?? const MessageModel(),
        messages ?? [],
        isRecording??false,
      ];
}

class MessageInitial extends MessageState {
  const MessageInitial();
}

class MessageLoadingState extends MessageState {}

class MessageErrorState extends MessageState {
  final String message;
   const MessageErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [
        message,
      ];
}

class AssetMessageState extends MessageState {
  final MessageModel messageModel;
   const AssetMessageState({
    required this.messageModel,
  });
  @override
  List<Object> get props => [
        messageModel,
      ];
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
  List<Object> get props => [
        currentLocation,
      ];
}
