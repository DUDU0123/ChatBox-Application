part of 'message_bloc.dart';

class MessageState extends Equatable {
   MessageState({
    this.isTyped,
    this.isAttachmentListOpened,
    this.isVideoPlaying = false,
  });
  final bool? isTyped;
  bool? isAttachmentListOpened;
  bool? isVideoPlaying;
  @override
  List<Object> get props => [isTyped ?? false, isAttachmentListOpened ?? false, isVideoPlaying??false,];
}

class MessageInitial extends MessageState {
   MessageInitial();
}

class MessageLoadingState extends MessageState {}

class MessageSucessState extends MessageState {
  final Stream<List<MessageModel>> messages;
   final MessageModel? messageModel;
   MessageSucessState({
    required this.messages,
    this.messageModel,
  });
  @override
  List<Object> get props => [messages,];
}

class MessageErrorState extends MessageState {
  final String message;
   MessageErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message,];
}
class AssetMessageState extends MessageState {
  final MessageModel messageModel;
  AssetMessageState({
    required this.messageModel,
  });
}
