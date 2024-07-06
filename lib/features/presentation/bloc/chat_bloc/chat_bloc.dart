import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:equatable/equatable.dart';
import 'package:chatbox/features/domain/repositories/chat_repo/chat_repo.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepo chatRepo;
  ChatBloc({
    required this.chatRepo,
  }) : super(ChatInitial()) {
    on<CreateANewChatEvent>(createANewChatEvent);
    on<GetAllChatsEvent>(getAllChatsEvent);
    on<MessageSentEvent>(messageSentEvent);
    on<GetAllMessageEvent>(getAllMessageEvent);
    on<GetOneMessageEvent>(getOneMessageEvent);
    on<MessageEditEvent>(messageEditEvent);
    on<MessageDeleteEvent>(messageDeleteEvent);
  }

  FutureOr<void> createANewChatEvent(
      CreateANewChatEvent event, Emitter<ChatState> emit) async {
    try {
      // await chatRepo.createNewChat(contactModel: event.contactModel);
      await chatRepo.createNewChat(
        receiverId: event.receiverId,
        recieverContactName: event.recieverContactName,
      );
      add(GetAllChatsEvent());
    } catch (e) {
      log("Create chat: e ${e.toString()}");
      emit(ChatErrorState(message: e.toString()));
    }
  }

  FutureOr<void> getAllChatsEvent(
      GetAllChatsEvent event, Emitter<ChatState> emit) {
    emit(ChatLoadingState());
    try {
      log("Get all chats event called");
      Stream<List<ChatModel>> chatList = chatRepo.getAllChats();
      //  log("Chat List: ${}");
      chatList.listen((vl) => log(vl[0].receiverProfileImage!));
      emit(ChatSuccessState(chatList: chatList));
    } catch (e) {
      log("Create chat: e ${e.toString()}");
      emit(ChatErrorState(message: e.toString()));
    }
  }

  FutureOr<void> messageSentEvent(
      MessageSentEvent event, Emitter<ChatState> emit) {}

  FutureOr<void> getAllMessageEvent(
      GetAllMessageEvent event, Emitter<ChatState> emit) {}

  FutureOr<void> getOneMessageEvent(
      GetOneMessageEvent event, Emitter<ChatState> emit) {}

  FutureOr<void> messageEditEvent(
      MessageEditEvent event, Emitter<ChatState> emit) {}

  FutureOr<void> messageDeleteEvent(
      MessageDeleteEvent event, Emitter<ChatState> emit) {}
}
