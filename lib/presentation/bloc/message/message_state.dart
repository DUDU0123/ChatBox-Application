part of 'message_bloc.dart';

class MessageState extends Equatable {
  const MessageState({this.isTyped});
  final bool? isTyped;
  @override
  List<Object> get props => [isTyped??false,];
}

class MessageInitial extends MessageState {
  const MessageInitial();
}

class MessageErrorState extends MessageState {
  final String message;
 const MessageErrorState({
    required this.message,
  });
}
