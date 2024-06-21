import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(const MessageInitial()) {
    on<MessageTypedEvent>(messageTypedEvent);
    on<AttachmentIconClickedEvent>(attachmentIconClickedEvent);
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
        final isAttacthmentListOpened = state.isAttachmentListOpened??false;
        emit(
          MessageState(isAttachmentListOpened: !isAttacthmentListOpened),
        );
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }
}
