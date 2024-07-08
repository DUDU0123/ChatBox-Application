import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/domain/repositories/chat_repo/chat_repo.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepo chatRepo;
  MessageBloc({
    required this.chatRepo,
  }) : super(const MessageInitial()) {
    on<MessageTypedEvent>(messageTypedEvent);
    on<AttachmentIconClickedEvent>(attachmentIconClickedEvent);
    on<MessageSentEvent>(messageSentEvent);
    on<GetAllMessageEvent>(getAllMessageEvent);
    on<GetOneMessageEvent>(getOneMessageEvent);
    on<MessageEditEvent>(messageEditEvent);
    on<MessageDeleteEvent>(messageDeleteEvent);
  }

  FutureOr<void> messageTypedEvent(
      MessageTypedEvent event, Emitter<MessageState> emit) {
    try {
      log(name: "Length:", event.textLength.toString());
      final bool isTyped = event.textLength > 0;
      emit(MessageState(isTyped: isTyped));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> attachmentIconClickedEvent(
      AttachmentIconClickedEvent event, Emitter<MessageState> emit) {
    try {
      log("Something");
      log(name: "Bool value", "${state.isAttachmentListOpened}");
      log("object");
      final isAttacthmentListOpened = state.isAttachmentListOpened ?? false;
      emit(
        MessageState(isAttachmentListOpened: !isAttacthmentListOpened),
      );
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }
   FutureOr<void> getAllMessageEvent(
      GetAllMessageEvent event, Emitter<MessageState> emit) async {
    try {
      final messages = chatRepo.getAllMessages(
        chatId: event.chatId,
      );
      emit(MessageSucessState(messages: messages));
    } catch (e) {
      log("Get message error: ${e.toString()}");
      emit(MessageErrorState(message: e.toString()));
    }
  }


  Future<FutureOr<void>> messageSentEvent(
      MessageSentEvent event, Emitter<MessageState> emit) async {
    try {
      await chatRepo.sendMessage(
        chatId: event.chatId,
        message: event.message,
      );
      add(GetAllMessageEvent(chatId: event.chatId));
    } catch (e) {
      log("Send message error: ${e.toString()}");
      emit(MessageErrorState(message: e.toString()));
    }
  }

 
  FutureOr<void> getOneMessageEvent(
      GetOneMessageEvent event, Emitter<MessageState> emit) {}

  FutureOr<void> messageEditEvent(
      MessageEditEvent event, Emitter<MessageState> emit) {}

  FutureOr<void> messageDeleteEvent(
      MessageDeleteEvent event, Emitter<MessageState> emit) {}
}
