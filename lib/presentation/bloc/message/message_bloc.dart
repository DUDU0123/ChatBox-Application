import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(const MessageInitial()) {
    on<MessageTypedEvent>(messageTypedEvent);
  }

  FutureOr<void> messageTypedEvent(
      MessageTypedEvent event, Emitter<MessageState> emit) {
        try {
          log(name: "Length:" ,event.textLength.toString());
          final bool isTyped = event.textLength>0;
          emit(MessageState(isTyped: isTyped));
        } catch (e) {
          emit(MessageErrorState(message: e.toString()));
        }
      }
}
