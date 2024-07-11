import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/chat_asset_send_methods.dart';
import 'package:chatbox/core/utils/image_picker_method.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:equatable/equatable.dart';

import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/domain/repositories/chat_repo/chat_repo.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepo chatRepo;
  // final UserRepository userRepository;
  MessageBloc({
    required this.chatRepo,
    // required this.userRepository,
  }) : super(MessageInitial()) {
    on<MessageTypedEvent>(messageTypedEvent);
    on<AttachmentIconClickedEvent>(attachmentIconClickedEvent);
    on<VideoMessagePlayEvent>(videoMessagePlayEvent);
    on<VideoMessageCompleteEvent>(videoMessageCompleteEvent);
    on<VideoMessagePauseEvent>(videoMessagePauseEvent);
    on<MessageSentEvent>(messageSentEvent);
    on<GetAllMessageEvent>(getAllMessageEvent);
    on<GetOneMessageEvent>(getOneMessageEvent);
    on<MessageEditEvent>(messageEditEvent);
    on<MessageDeleteEvent>(messageDeleteEvent);
    on<PhotoMessageSendEvent>(photoMessageSendEvent);
    on<VideoMessageSendEvent>(videoMessageSendEvent);
    on<ContactMessageSendEvent>(contactMessageSendEvent);
    on<OpenDeviceFileAndSaveToDbEvent>(openDeviceFileAndSaveToDbEvent);
    on<AudioMessageSendEvent>(audioMessageSendEvent);
    on<AudioRecordToggleEvent>(audioRecordToggleEvent);
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

  FutureOr<void> getOneMessageEvent(
      GetOneMessageEvent event, Emitter<MessageState> emit) {}

  FutureOr<void> messageEditEvent(
      MessageEditEvent event, Emitter<MessageState> emit) {}

  FutureOr<void> messageDeleteEvent(
      MessageDeleteEvent event, Emitter<MessageState> emit) {}

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

  FutureOr<void> photoMessageSendEvent(
      PhotoMessageSendEvent event, Emitter<MessageState> emit) async {
    emit(MessageLoadingState());
    try {
      final File? imageFile = await pickImage(imageSource: event.imageSource);
      final String chatID = event.chatModel.chatID.toString();
      if (imageFile != null) {
        final imageUrl = await chatRepo.sendAssetMessage(
          chatID: chatID,
          file: imageFile,
        );
        MessageModel photoMessage = MessageModel(
          message: imageUrl,
          messageType: MessageType.photo,
          messageTime: DateTime.now().toString(),
          messageStatus: MessageStatus.sent,
          isDeletedMessage: false,
          isEditedMessage: false,
          isPinnedMessage: false,
          isStarredMessage: false,
          receiverID: event.chatModel.receiverID,
          senderID: event.chatModel.senderID,
        );
        await chatRepo.sendMessage(chatId: chatID, message: photoMessage);
        // add(GetAllMessageEvent(chatId: chatID, ));
        final messages = chatRepo.getAllMessages(
          chatId: chatID,
        );
        emit(
            MessageSucessState(messages: messages, messageModel: photoMessage));
      }
    } catch (e) {
      log("Send photo message error: ${e.toString()}");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> videoMessageSendEvent(
      VideoMessageSendEvent event, Emitter<MessageState> emit) async {
    emit(MessageLoadingState());
    try {
      final File? videoFile =
          await takeVideoAsset(imageSource: event.imageSource);
      final String chatID = event.chatModel.chatID.toString();
      if (videoFile != null) {
        final videoUrl = await chatRepo.sendAssetMessage(
          chatID: chatID,
          file: videoFile,
        );
        MessageModel videoMessage = MessageModel(
          message: videoUrl,
          messageType: MessageType.video,
          messageTime: DateTime.now().toString(),
          messageStatus: MessageStatus.sent,
          isDeletedMessage: false,
          isEditedMessage: false,
          isPinnedMessage: false,
          isStarredMessage: false,
          receiverID: event.chatModel.receiverID,
          senderID: event.chatModel.senderID,
        );
        await chatRepo.sendMessage(chatId: chatID, message: videoMessage);
        // add(GetAllMessageEvent(chatId: chatID));
        final messages = chatRepo.getAllMessages(
          chatId: chatID,
        );
        emit(
            MessageSucessState(messages: messages, messageModel: videoMessage));
      }
    } catch (e) {
      log("Send photo message error: ${e.toString()}");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> videoMessagePlayEvent(
      VideoMessagePlayEvent event, Emitter<MessageState> emit) {
    try {
      if (state.isVideoPlaying == null) {
        log("State video playing null");
        return null;
      }
      emit(MessageState(isVideoPlaying: !state.isVideoPlaying!));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> videoMessageCompleteEvent(
      VideoMessageCompleteEvent event, Emitter<MessageState> emit) {
    try {
      emit(MessageState(isVideoPlaying: false));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> videoMessagePauseEvent(
      VideoMessagePauseEvent event, Emitter<MessageState> emit) {
    try {
      emit(MessageState(isVideoPlaying: false));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> contactMessageSendEvent(
      ContactMessageSendEvent event, Emitter<MessageState> emit) async {
    try {
      final String? chatID = event.chatModel.chatID;
      if (chatID == null) {
        return null;
      }
      for (var contactModel in event.contactListToSend) {
        MessageModel message = MessageModel(
          message: contactModel.userContactNumber,
          messageType: MessageType.contact,
          messageTime: DateTime.now().toString(),
          messageStatus: MessageStatus.sent,
          isDeletedMessage: false,
          isEditedMessage: false,
          isPinnedMessage: false,
          isStarredMessage: false,
          receiverID: event.chatModel.receiverID,
          senderID: event.chatModel.senderID,
        );
        await chatRepo.sendMessage(chatId: chatID, message: message);
      }
    } catch (e) {
      log("Contact message send error");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> openDeviceFileAndSaveToDbEvent(
      OpenDeviceFileAndSaveToDbEvent event, Emitter<MessageState> emit) async {
    try {
      List<File?> filesPicked = await pickMultipleFileWithAnyExtension();
      final String? chatID = event.chatModel.chatID;
      if (chatID == null) {
        return null;
      }
      for (var file in filesPicked) {
        if (file != null) {
          final fileUrl = await chatRepo.sendAssetMessage(
            chatID: chatID,
            file: file,
          );
          String fileName = file.path.split('/').last;
          MessageModel message = MessageModel(
            name: fileName,
            message: fileUrl,
            messageType: MessageType.document,
            messageTime: DateTime.now().toString(),
            messageStatus: MessageStatus.sent,
            isDeletedMessage: false,
            isEditedMessage: false,
            isPinnedMessage: false,
            isStarredMessage: false,
            receiverID: event.chatModel.receiverID,
            senderID: event.chatModel.senderID,
          );
          await chatRepo.sendMessage(chatId: chatID, message: message);
        }
      }
    } catch (e) {
      log("File pick document message send error");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> audioRecordToggleEvent(
      AudioRecordToggleEvent event, Emitter<MessageState> emit) async {
    try {
      if (event.recorder.isRecording) {
        String? path = await event.recorder.stopRecorder();
        if (path != null) {
          File audioFile = File(path);
          add(AudioMessageSendEvent(chatModel: event.chatModel, audioFile: audioFile,),);
        }
      } else {
        await initRecorder(recorder: event.recorder);
        await event.recorder.startRecorder(toFile: 'audio');
      }
    } catch (e) {
      log("Audio record error");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> audioMessageSendEvent(
      AudioMessageSendEvent event, Emitter<MessageState> emit) async {
    try {
      final String? chatID = event.chatModel.chatID;
      if (chatID == null) {
        return null;
      }

      final fileUrl = await chatRepo.sendAssetMessage(
        chatID: chatID,
        file: event.audioFile,
      );
      MessageModel message = MessageModel(
        message: fileUrl,
        messageType: MessageType.audio,
        messageTime: DateTime.now().toString(),
        messageStatus: MessageStatus.sent,
        isDeletedMessage: false,
        isEditedMessage: false,
        isPinnedMessage: false,
        isStarredMessage: false,
        receiverID: event.chatModel.receiverID,
        senderID: event.chatModel.senderID,
      );
      await chatRepo.sendMessage(chatId: chatID, message: message);
    } catch (e) {
      log("Audio message send error");
      emit(MessageErrorState(message: e.toString()));
    }
  }
}