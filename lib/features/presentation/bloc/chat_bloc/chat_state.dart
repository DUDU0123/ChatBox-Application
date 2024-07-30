part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final Stream<List<ChatModel>>? chatList;
  const ChatState({this.chatList});
  @override
  List<Object> get props => [chatList??[]];
}

class ChatInitial extends ChatState {}
class ChatLoadingState extends ChatState{}
class ChatSuccessState extends ChatState {
  // final Stream<List<ChatModel>> chatList;
  // const ChatSuccessState({
  //   required this.chatList,
  // });
  @override
  List<Object> get props => [];
}
class ChatErrorState extends ChatState {
  final String message;
  const ChatErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
