import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/image_picker_method.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/repositories/user_repository/user_repository_impl.dart';
import 'package:chatbox/features/domain/repositories/user_repo/user_repository.dart';
import 'package:equatable/equatable.dart';

import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/domain/repositories/chat_repo/chat_repo.dart';
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
    on<MessageSentEvent>(messageSentEvent);
    on<GetAllMessageEvent>(getAllMessageEvent);
    on<GetOneMessageEvent>(getOneMessageEvent);
    on<MessageEditEvent>(messageEditEvent);
    on<MessageDeleteEvent>(messageDeleteEvent);
    on<PhotoMessageSendEvent>(photoMessageSendEvent);
    // on<AssetMessageSendEvent>(assetMessageSendEvent);
    on<VideoMessageSendEvent>(videoMessageSendEvent);
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
      // if (event.message.messageType != MessageType.text) {
      //   if (event.file != null) {
      //     final filePath = await userRepository.saveUserFileToDBStorage(
      //         ref: "${event.chatId}/${DateTime.now()}", file: event.file!);
      //     await chatRepo.sendMessage(
      //       chatId: event.chatId,
      //       message: MessageModel(
      //         attachmentsWithMessage: event.message.attachmentsWithMessage,
      //         isDeletedMessage: event.message.isDeletedMessage,
      //         isEditedMessage: event.message.isEditedMessage,
      //         isPinnedMessage: event.message.isPinnedMessage,
      //         isStarredMessage: event.message.isStarredMessage,
      //         messageContent: filePath,
      //         messageId: event.message.messageId,
      //         messageStatus: event.message.messageStatus,
      //         messageTime: event.message.messageTime,
      //         messageType: event.message.messageType,
      //         receiverID: event.message.receiverID,
      //         senderID: event.message.senderID,
      //       ),
      //     );
      //     add(GetAllMessageEvent(chatId: event.chatId));
      //   } else {
      //     log("File is null message bloc");
      //   }
      // }
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

  FutureOr<void> photoMessageSendEvent(
      PhotoMessageSendEvent event, Emitter<MessageState> emit) async {
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
        chatRepo.sendMessage(chatId: chatID, message: photoMessage);
        add(GetAllMessageEvent(chatId: chatID));
      }
    } catch (e) {
      log("Send photo message error: ${e.toString()}");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> videoMessageSendEvent(
      VideoMessageSendEvent event, Emitter<MessageState> emit) async {
    try {
      final File? videoFile = await takeVideoAsset(imageSource: event.imageSource);
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
        chatRepo.sendMessage(chatId: chatID, message: videoMessage);
        add(GetAllMessageEvent(chatId: chatID));
      }
    } catch (e) {
      log("Send photo message error: ${e.toString()}");
      emit(MessageErrorState(message: e.toString()));
    }
  }

}
