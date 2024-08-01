part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final Stream<List<ChatModel>>? chatList;
  final File? pickedFile;
  const ChatState({
    this.chatList,
    this.pickedFile,
  });

  ChatState copyWith({
    Stream<List<ChatModel>>? chatList,
    File? pickedFile,
  }) {
    return ChatState(
      chatList: chatList ?? this.chatList,
      pickedFile: pickedFile ?? this.pickedFile,
    );
  }

  @override
  List<Object> get props => [
        chatList ?? [],
        pickedFile ?? File(''),
      ];
}

class ChatInitial extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatErrorState extends ChatState {
  final String message;
  const ChatErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
