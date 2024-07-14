import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/chat_asset_send_methods.dart';
import 'package:chatbox/core/utils/image_picker_method.dart';
import 'package:chatbox/features/data/data_sources/chat_data/chat_data.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:equatable/equatable.dart';

import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/domain/repositories/chat_repo/chat_repo.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    on<AudioPlayerPositionChangedEvent>(onAudioPlayerPositionChanged);
    on<AudioPlayerDurationChangedEvent>(onAudioPlayerDurationChanged);
    on<AudioPlayerPlayStateChangedEvent>(onAudioPlayerPlayStateChanged);
    on<AudioPlayerCompletedEvent>(_onAudioPlayerCompleted);
    on<LocationPickEvent>(locationPickEvent);
    on<LocationMessageSendEvent>(locationMessageSendEvent);
    // // other events
    // on<UserStatusChangedEvent>(userStatusChangedEvent);
    on<ChatOpenedEvent>(chatOpenedEvent);
    on<ChatClosedEvent>(chatClosedEvent);
  }

  FutureOr<void> messageTypedEvent(
      MessageTypedEvent event, Emitter<MessageState> emit) {
    try {
      log(name: "Length:", event.textLength.toString());
      final bool isTyped = event.textLength > 0;
      emit(MessageState(isTyped: isTyped, messages: state.messages));
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
      state.messages?.listen((v) {
        log(name: "Length message atat", v.length.toString());
      });
      final isAttacthmentListOpened = state.isAttachmentListOpened ?? false;
      emit(state.copyWith(
          isAttachmentListOpened: !isAttacthmentListOpened,
          messages: state.messages));
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
      // emit(MessageSucessState(messages: messages));
      emit(MessageState(messages: messages));
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
      if (event.chatModel.chatID == null) {
        return null;
      }
      await chatRepo.sendMessage(
        chatId: event.chatModel.chatID.toString(),
        message: event.message,
      );
      ChatData.updateChatMessageDataOfUser(
          chatModel: event.chatModel, message: event.message);
      add(GetAllMessageEvent(
        chatId: event.chatModel.chatID.toString(),
      ));
    } catch (e) {
      log("Send message error: ${e.toString()}");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> photoMessageSendEvent(
      PhotoMessageSendEvent event, Emitter<MessageState> emit) async {
    // emit(MessageLoadingState());
    try {
      final File? imageFile = await pickImage(imageSource: event.imageSource);
      final String? chatID = event.chatModel.chatID;
      if (chatID == null) {
        return null;
      }
      if (imageFile != null) {
        final imageUrl = await chatRepo.sendAssetMessage(
          chatID: chatID,
          file: imageFile,
        );
        MessageModel photoMessage = MessageModel(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
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
        ChatData.updateChatMessageDataOfUser(
          chatModel: event.chatModel,
          message: photoMessage,
        );
        // add(GetAllMessageEvent(chatId: chatID, ));
        final messages = chatRepo.getAllMessages(
          chatId: chatID,
        );
        // emit(
        //     MessageSucessState(messages: messages, messageModel: photoMessage));
        emit(MessageState(
            messages: state.messages ?? messages, messagemodel: photoMessage));
      }
    } catch (e) {
      log("Send photo message error: ${e.toString()}");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> videoMessageSendEvent(
      VideoMessageSendEvent event, Emitter<MessageState> emit) async {
    // emit(MessageLoadingState());
    try {
      final File? videoFile =
          await takeVideoAsset(imageSource: event.imageSource);
      final String? chatID = event.chatModel.chatID;
      if (chatID == null) {
        return null;
      }
      if (videoFile != null) {
        final videoUrl = await chatRepo.sendAssetMessage(
          chatID: chatID,
          file: videoFile,
        );
        MessageModel videoMessage = MessageModel(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
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
        ChatData.updateChatMessageDataOfUser(
            chatModel: event.chatModel, message: videoMessage);
        // add(GetAllMessageEvent(chatId: chatID));
        final messages = chatRepo.getAllMessages(
          chatId: chatID,
        );
        // emit(
        //     MessageSucessState(messages: messages, messageModel: videoMessage));
        emit(MessageState(
            messages: state.messages ?? messages, messagemodel: videoMessage));
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

      // emit(state.copyWith(isVideoPlaying: true));
      emit(MessageState(
        isVideoPlaying: true,
        messages: state.messages,
        isAttachmentListOpened: state.isAttachmentListOpened,
        messagemodel: state.messagemodel,
        isTyped: state.isTyped,
      ));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> videoMessageCompleteEvent(
      VideoMessageCompleteEvent event, Emitter<MessageState> emit) {
    try {
      // emit(const MessageState(isVideoPlaying: false));
      emit(state.copyWith(isVideoPlaying: false));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> videoMessagePauseEvent(
      VideoMessagePauseEvent event, Emitter<MessageState> emit) {
    try {
      // emit(const MessageState(isVideoPlaying: false));
      // emit(state.copyWith(isVideoPlaying: false));
      emit(state.copyWith(
        isVideoPlaying: false,
        messages: state.messages,
        isAttachmentListOpened: state.isAttachmentListOpened,
        messagemodel: state.messagemodel,
        isTyped: state.isTyped,
      ));
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
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
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
        ChatData.updateChatMessageDataOfUser(
            chatModel: event.chatModel, message: message);
        final messages = chatRepo.getAllMessages(
          chatId: chatID,
        );
        // emit(MessageSucessState(messages: messages, messageModel: message));
        emit(MessageState(
          messages: state.messages ?? messages,
          isAttachmentListOpened: state.isAttachmentListOpened,
          messagemodel: message,
          isTyped: state.isTyped,
        ));
      }
    } catch (e) {
      log("Contact message send error");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> openDeviceFileAndSaveToDbEvent(
      OpenDeviceFileAndSaveToDbEvent event, Emitter<MessageState> emit) async {
    // emit(MessageLoadingState());
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
            messageId: DateTime.now().millisecondsSinceEpoch.toString(),
            name: fileName,
            message: fileUrl,
            messageType: event.messageType,
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
          ChatData.updateChatMessageDataOfUser(
              chatModel: event.chatModel, message: message);
          final messages = chatRepo.getAllMessages(
            chatId: chatID,
          );
          // emit(MessageSucessState(messages: messages, messageModel: message));
          emit(MessageState(
            messages: state.messages ?? messages,
            isAttachmentListOpened: state.isAttachmentListOpened,
            messagemodel: message,
            isTyped: state.isTyped,
          ));
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
          add(
            AudioMessageSendEvent(
              chatModel: event.chatModel,
              audioFile: audioFile,
            ),
          );
        }
        emit(state.copyWith(
          isRecording: false,
          messages: state.messages,
        ));
      } else {
        await initRecorder(recorder: event.recorder);
        await event.recorder.startRecorder(toFile: 'audio');
        emit(state.copyWith(
          isRecording: true,
          messages: state.messages,
        ));
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
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
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
      ChatData.updateChatMessageDataOfUser(
          chatModel: event.chatModel, message: message);
      final messages = chatRepo.getAllMessages(
        chatId: chatID,
      );
      // emit(MessageSucessState(messages: messages, messageModel: message));
      emit(MessageState(
        messages: state.messages ?? messages,
        isAttachmentListOpened: state.isAttachmentListOpened,
        messagemodel: message,
        isTyped: state.isTyped,
        isRecording: false,
      ));
    } catch (e) {
      log("Audio message send error");
      emit(MessageErrorState(message: e.toString()));
    }
  }
  FutureOr<void> onAudioPlayerPositionChanged(
      AudioPlayerPositionChangedEvent event, Emitter<MessageState> emit) {
    final newAudioPositions = Map<String, Duration>.from(state.audioPositions);
    newAudioPositions[event.messageKey] = event.position;
    emit(state.copyWith(audioPositions: newAudioPositions));
  }

  FutureOr<void> onAudioPlayerDurationChanged(
      AudioPlayerDurationChangedEvent event, Emitter<MessageState> emit) {
    final newAudioDurations = Map<String, Duration>.from(state.audioDurations);
    newAudioDurations[event.messageKey] = event.duration;
    emit(state.copyWith(audioDurations: newAudioDurations));
  }

  FutureOr<void> onAudioPlayerPlayStateChanged(
      AudioPlayerPlayStateChangedEvent event, Emitter<MessageState> emit) {
    final newAudioPlayingStates = Map<String, bool>.from(state.audioPlayingStates);
    newAudioPlayingStates[event.messageKey] = event.isPlaying;
    emit(state.copyWith(audioPlayingStates: newAudioPlayingStates));
  }
  FutureOr<void> _onAudioPlayerCompleted(
      AudioPlayerCompletedEvent event, Emitter<MessageState> emit) {
    final newAudioPositions = Map<String, Duration>.from(state.audioPositions);
    newAudioPositions[event.messageKey] = Duration.zero;
    final newAudioPlayingStates = Map<String, bool>.from(state.audioPlayingStates);
    newAudioPlayingStates[event.messageKey] = false;
    emit(state.copyWith(
      audioPositions: newAudioPositions,
      audioPlayingStates: newAudioPlayingStates,
    ));
  }
  Future<FutureOr<void>> locationMessageSendEvent(
      LocationMessageSendEvent event, Emitter<MessageState> emit) async {
    try {
      final String? chatID = event.chatModel.chatID;
      if (chatID == null) {
        return null;
      }
      MessageModel message = MessageModel(
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        message: event.location,
        messageType: MessageType.location,
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
      ChatData.updateChatMessageDataOfUser(
          chatModel: event.chatModel, message: message);
      final messages = chatRepo.getAllMessages(
        chatId: chatID,
      );
      // emit(MessageSucessState(messages: messages, messageModel: message));
      emit(MessageState(
        messages: state.messages ?? messages,
        isAttachmentListOpened: state.isAttachmentListOpened,
        messagemodel: message,
        isTyped: state.isTyped,
      ));
    } catch (e) {
      log("Location send error");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> locationPickEvent(
      LocationPickEvent event, Emitter<MessageState> emit) async {
    try {
      // await Geolocator.requestPermission();
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        await Geolocator.openLocationSettings();
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position currentPosition = await Geolocator.getCurrentPosition();
        currentPosition.latitude;
        currentPosition.longitude;
        LatLng currentLocation =
            LatLng(currentPosition.latitude, currentPosition.longitude);

        emit(CurrentLocationState(
          currentLocation: currentLocation,
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude,
        ));
      } else {
        emit(const MessageErrorState(message: "Location not found"));
      }
    } catch (e) {
      log("Location pick error");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> chatOpenedEvent(
      ChatOpenedEvent event, Emitter<MessageState> emit) {}

  FutureOr<void> chatClosedEvent(
      ChatClosedEvent event, Emitter<MessageState> emit) {}
}
