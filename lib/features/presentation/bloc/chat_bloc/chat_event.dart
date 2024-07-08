part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class CreateANewChatEvent extends ChatEvent {
  final String recieverContactName;
  final String receiverId;
  // final ContactModel contactModel;
  const CreateANewChatEvent({
    required this.recieverContactName,
    required this.receiverId,
  });
  @override
  List<Object> get props => [receiverId,recieverContactName,];
}
class GetAllChatsEvent extends ChatEvent{}
class DeletAChatEvent extends ChatEvent {
  final ChatModel chatModel;
  const DeletAChatEvent({
    required this.chatModel,
  });
  @override
  List<Object> get props => [chatModel,];
}
class MessageSentEvent extends ChatEvent {
  final String chatId;
  final MessageModel message;
 const MessageSentEvent({
    required this.chatId,
    required this.message,
  });
  @override
  List<Object> get props => [chatId,message,];
}
class GetOneMessageEvent extends ChatEvent{}
class GetAllMessageEvent extends ChatEvent {
  final String chatId;
  const GetAllMessageEvent({
    required this.chatId,
  });
}
class MessageDeleteEvent extends ChatEvent{}
class MessageEditEvent extends ChatEvent{}