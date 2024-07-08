part of 'message_bloc.dart';

class MessageState extends Equatable {
  const MessageState({
    this.isTyped,
    this.isAttachmentListOpened,
  });
  final bool? isTyped;
  final bool? isAttachmentListOpened;
  @override
  List<Object> get props => [isTyped ?? false, isAttachmentListOpened ?? false];
}

class MessageInitial extends MessageState {
  const MessageInitial();
}

class MessageLoadingState extends MessageState {}

class MessageSucessState extends MessageState {
  final Stream<List<MessageModel>> messages;
  const MessageSucessState({
    required this.messages,
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
