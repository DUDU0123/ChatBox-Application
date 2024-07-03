part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class CreateANewChatEvent extends ChatEvent {
  final ContactModel contactModel;
  const CreateANewChatEvent({
    required this.contactModel,
  });
  @override
  List<Object> get props => [contactModel,];
}
class GetAllChatsEvent extends ChatEvent{}
class MessageSentEvent extends ChatEvent{}
class GetOneMessageEvent extends ChatEvent{}
class GetAllMessageEvent extends ChatEvent{}
class MessageDeleteEvent extends ChatEvent{}
class MessageEditEvent extends ChatEvent{}