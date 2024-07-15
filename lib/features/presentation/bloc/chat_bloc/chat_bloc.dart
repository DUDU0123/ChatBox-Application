import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:equatable/equatable.dart';
import 'package:chatbox/features/domain/repositories/chat_repo/chat_repo.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepo chatRepo;
  ChatBloc({
    required this.chatRepo,
  }) : super(ChatInitial()) {
   // on<CreateANewChatEvent>(createANewChatEvent);
    on<GetAllChatsEvent>(getAllChatsEvent);
    on<DeletAChatEvent>(deleteAChatEvent);
    
  }

  // FutureOr<void> createANewChatEvent(
  //     CreateANewChatEvent event, Emitter<ChatState> emit) async {
  //   try {
  //     await chatRepo.createNewChat(
  //       receiverId: event.receiverId,
  //       recieverContactName: event.recieverContactName,
  //     );
  //     add(GetAllChatsEvent());
  //   } catch (e) {
  //     log("Create chat: e ${e.toString()}");
  //     emit(ChatErrorState(message: e.toString()));
  //   }
  // }

  FutureOr<void> getAllChatsEvent(
      GetAllChatsEvent event, Emitter<ChatState> emit) {
    emit(ChatLoadingState());
    try {
      log("Get all chats event called");
      Stream<List<ChatModel>> chatList = chatRepo.getAllChats();
      emit(ChatSuccessState(chatList: chatList));
    } catch (e) {
      log("Create chat: e ${e.toString()}");
      emit(ChatErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> deleteAChatEvent(
      DeletAChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    try {
      chatRepo.deleteAChat(
        chatModel: event.chatModel,
      );
      add(GetAllChatsEvent());
    } catch (e) {
      log("Delete chat: e ${e.toString()}");
      emit(ChatErrorState(message: e.toString()));
    }
  }
}
