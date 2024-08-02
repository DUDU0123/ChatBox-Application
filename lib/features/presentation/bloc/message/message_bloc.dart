import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/chat_asset_send_methods.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/image_picker_method.dart';
import 'package:chatbox/features/data/data_sources/message_data/message_data.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/domain/repositories/message_repo/message_repo.dart';
import 'package:chatbox/core/utils/message_methods.dart';
import 'package:equatable/equatable.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/domain/repositories/chat_repo/chat_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepo chatRepo;
  final MessageRepo messageRepository;
  MessageBloc({
    required this.chatRepo,
    required this.messageRepository,
  }) : super(const MessageInitial()) {
    on<MessageTypedEvent>(messageTypedEvent);
    on<AttachmentIconClickedEvent>(attachmentIconClickedEvent);
    on<VideoMessagePlayEvent>(videoMessagePlayEvent);
    on<VideoMessageCompleteEvent>(videoMessageCompleteEvent);
    on<VideoMessagePauseEvent>(videoMessagePauseEvent);
    on<MessageSentEvent>(messageSentEvent);
    on<GetAllMessageEvent>(getAllMessageEvent);
    on<GetOneMessageEvent>(getOneMessageEvent);
    on<MessageEditEvent>(messageEditEvent);
    on<MessageDeleteForEveryOneEvent>(messageDeleteForEveryOneEvent);
    on<MessageDeleteForOne>(messageDeleteForOne);
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
    on<MessageSelectedEvent>(messageSelectedEvent);
    on<GetMessageDateEvent>(getMessageDateEvent);
    on<GetReplyMessageEvent>(getReplyMessageEvent);
    on<UnSelectEvent>(unSelectEvent);
   
  }


  FutureOr<void> getMessageDateEvent(
      GetMessageDateEvent event, Emitter<MessageState> emit) {
    try {
      emit(state.copyWith(
        messageDate: event.currentMessageDate,
      ));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
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
      if (event.isGroup == null && event.groupModel == null) {
        return;
      }
      if (!event.isGroup! && event.chatId == null) {
        return;
      }
      if (event.isGroup!) {
        if (event.groupModel?.groupID != null) {
          log(name: "get all", "${event.groupModel}");
          final messages = messageRepository.getAllMessageOfAGroupChat(
            groupID: event.groupModel!.groupID!,
          );
          messages?.listen((v) {
            log(name: "Length mess", v.length.toString());
          });
          emit(MessageState(messages: messages));
        } else {
          return;
        }
      } else {
        final messages = messageRepository.getAllMessages(
          isGroup: event.isGroup ?? false,
          chatId: event.chatId!,
        );
        emit(MessageState(messages: messages));
        // }
      }
    } catch (e) {
      log("Get message error: ${e.toString()}");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> getOneMessageEvent(
      GetOneMessageEvent event, Emitter<MessageState> emit) {}

  Future<FutureOr<void>> messageEditEvent(
      MessageEditEvent event, Emitter<MessageState> emit) async {
    try {
      final value = await messageRepository.editMessage(
        messageId: event.messageID,
        updatedMessage: event.updatedMessage,
        isGroup: event.isGroup,
        chatModel: event.chatModel,
        groupModel: event.groupModel,
      );
      log(value.toString());
      emit(state.copyWith(messages: state.messages));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  Future<FutureOr<void>> messageSentEvent(
      MessageSentEvent event, Emitter<MessageState> emit) async {
    try {
      log('Sending nessage');

      if (event.isGroup) {
        final value = await messageRepository.sendMessageToAGroupChat(
          groupID: event.groupModel?.groupID,
          message: event.message,
        );
        log("Group message: $value");
      } else {
        if (event.message.senderID != null &&
            event.message.receiverID != null &&
            event.chatModel?.chatID == null) {
          final chatId = CommonDBFunctions.generateChatId(
              currentUserId: event.message.senderID!,
              receiverId: event.message.receiverID!);
          await messageRepository.sendMessage(
            chatId: chatId,
            message: event.message,
            receiverContactName: event.receiverContactName,
            receiverId: event.receiverContactName,
          );
        } else {
          await messageRepository.sendMessage(
            chatId: event.chatModel!.chatID,
            message: event.message,
            receiverContactName: event.receiverContactName,
            receiverId: event.receiverContactName,
          );
        }
        log('Sended one to one message');
      }

      MessageData.updateChatMessageDataOfUser(
        isGroup: event.isGroup,
        chatModel: event.chatModel,
        message: event.message,
        groupModel: event.groupModel,
      );
      add(GetAllMessageEvent(
        currentUserId: event.currentUserId,
        receiverId: event.receiverID,
        isGroup: event.isGroup,
        groupModel: event.groupModel,
        chatId: event.chatModel?.chatID,
      ));
    } catch (e) {
      log("Send message error: ${e.toString()}");
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> photoMessageSendEvent(
      PhotoMessageSendEvent event, Emitter<MessageState> emit) async {
    try {
      final File? imageFile = event.imageFile;
      final String? chatID = event.chatModel?.chatID;
      if (chatID == null && !event.isGroup) {
        return null;
      }
      if (event.groupModel == null && event.isGroup) {
        return;
      }
      if (imageFile != null) {
        final imageUrl = await messageRepository.sendAssetMessage(
          chatID: chatID,
          groupID: event.groupModel?.groupID,
          file: imageFile,
        );
        MessageModel photoMessage;
        if (event.isGroup) {
          photoMessage = MessageModel(
            name: event.messageCaption,
            message: imageUrl,
            messageType: MessageType.photo,
            messageTime: DateTime.now().toString(),
            messageStatus: MessageStatus.sent,
            isDeletedMessage: false,
            isEditedMessage: false,
            isPinnedMessage: false,
            isStarredMessage: false,
            senderID: firebaseAuth.currentUser?.uid,
          );
          final value = await messageRepository.sendMessageToAGroupChat(
            groupID: event.groupModel?.groupID,
            message: photoMessage,
          );
          log("Group message: $value");
        } else {
          photoMessage = MessageModel(
            name: event.messageCaption,
            messageId: DateTime.now().millisecondsSinceEpoch.toString(),
            message: imageUrl,
            messageType: MessageType.photo,
            messageTime: DateTime.now().toString(),
            messageStatus: MessageStatus.sent,
            isDeletedMessage: false,
            isEditedMessage: false,
            isPinnedMessage: false,
            isStarredMessage: false,
            receiverID: event.chatModel?.receiverID,
            senderID: event.chatModel?.senderID,
          );
          await messageRepository.sendMessage(
            chatId: chatID,
            message: photoMessage,
            receiverContactName: event.receiverContactName,
            receiverId: event.receiverContactName,
          );
        }
        MessageData.updateChatMessageDataOfUser(
          chatModel: event.chatModel,
          isGroup: event.isGroup,
          message: photoMessage,
          groupModel: event.groupModel,
        );
        final messages = messageRepository.getAllMessages(
          isGroup: event.isGroup,
          groupModel: event.groupModel,
          chatId: chatID,
        );
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
      // final File? videoFile =
      //     await takeVideoAsset(imageSource: event.imageSource);
      final File? videoFile = event.videoFile;
      final String? chatID = event.chatModel?.chatID;
      if (chatID == null && !event.isGroup) {
        return null;
      }
      if (event.groupModel == null && event.isGroup) {
        return;
      }
      if (videoFile != null) {
        final videoUrl = await messageRepository.sendAssetMessage(
          chatID: chatID,
          groupID: event.groupModel?.groupID,
          file: videoFile,
        );
        MessageModel videoMessage;
        if (event.isGroup) {
          videoMessage = MessageModel(
            name: event.messageCaption,
            message: videoUrl,
            messageType: MessageType.video,
            messageTime: DateTime.now().toString(),
            messageStatus: MessageStatus.sent,
            isDeletedMessage: false,
            isEditedMessage: false,
            isPinnedMessage: false,
            isStarredMessage: false,
            senderID: firebaseAuth.currentUser?.uid,
          );
          final value = await messageRepository.sendMessageToAGroupChat(
            groupID: event.groupModel?.groupID,
            message: videoMessage,
          );
          log("Group message: $value");
        } else {
          videoMessage = MessageModel(
            name: event.messageCaption,
            messageId: DateTime.now().millisecondsSinceEpoch.toString(),
            message: videoUrl,
            messageType: MessageType.video,
            messageTime: DateTime.now().toString(),
            messageStatus: MessageStatus.sent,
            isDeletedMessage: false,
            isEditedMessage: false,
            isPinnedMessage: false,
            isStarredMessage: false,
            receiverID: event.chatModel?.receiverID,
            senderID: event.chatModel?.senderID,
          );
          await messageRepository.sendMessage(
            chatId: chatID,
            message: videoMessage,
            receiverContactName: event.receiverContactName,
            receiverId: event.receiverContactName,
          );
        }

        MessageData.updateChatMessageDataOfUser(
          isGroup: event.isGroup,
          chatModel: event.chatModel,
          groupModel: event.groupModel,
          message: videoMessage,
        );
        final messages = messageRepository.getAllMessages(
          isGroup: event.isGroup,
          groupModel: event.groupModel,
          chatId: chatID,
        );
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
      emit(state.copyWith(isVideoPlaying: false));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> videoMessagePauseEvent(
      VideoMessagePauseEvent event, Emitter<MessageState> emit) {
    try {
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
      final String? chatID = event.chatModel?.chatID;
      if (chatID == null && !event.isGroup) {
        return null;
      }
      if (event.groupModel == null && event.isGroup) {
        return null;
      }
      for (var contactModel in event.contactListToSend) {
        MessageModel message;
        if (event.isGroup) {
          message = MessageModel(
            message: contactModel.userContactNumber,
            messageType: MessageType.contact,
            messageTime: DateTime.now().toString(),
            messageStatus: MessageStatus.sent,
            isDeletedMessage: false,
            isEditedMessage: false,
            isPinnedMessage: false,
            isStarredMessage: false,
            senderID: firebaseAuth.currentUser?.uid,
          );
          final value = await messageRepository.sendMessageToAGroupChat(
            groupID: event.groupModel?.groupID,
            message: message,
          );
          log("Group message: $value");
        } else {
          message = MessageModel(
            messageId: DateTime.now().millisecondsSinceEpoch.toString(),
            message: contactModel.userContactNumber,
            messageType: MessageType.contact,
            messageTime: DateTime.now().toString(),
            messageStatus: MessageStatus.sent,
            isDeletedMessage: false,
            isEditedMessage: false,
            isPinnedMessage: false,
            isStarredMessage: false,
            receiverID: event.chatModel?.receiverID,
            senderID: event.chatModel?.senderID,
          );
          await messageRepository.sendMessage(
            chatId: chatID,
            message: message,
            receiverContactName: event.receiverContactName,
            receiverId: event.receiverContactName,
          );
        }
        MessageData.updateChatMessageDataOfUser(
            isGroup: event.isGroup,
            chatModel: event.chatModel,
            groupModel: event.groupModel,
            message: message);
        final messages = messageRepository.getAllMessages(
          isGroup: event.isGroup,
          groupModel: event.groupModel,
          chatId: chatID,
        );
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
      final String? chatID = event.chatModel?.chatID;
      if (chatID == null && !event.isGroup) {
        return null;
      }
      if (event.groupModel == null && event.isGroup) {
        return null;
      }
      for (var file in filesPicked) {
        if (file != null) {
          final fileUrl = await messageRepository.sendAssetMessage(
            chatID: chatID,
            file: file,
          );
          String fileName = file.path.split('/').last;
          MessageModel message;
          if (event.isGroup) {
            message = MessageModel(
              name: fileName,
              message: fileUrl,
              messageType: event.messageType,
              messageTime: DateTime.now().toString(),
              messageStatus: MessageStatus.sent,
              isDeletedMessage: false,
              isEditedMessage: false,
              isPinnedMessage: false,
              isStarredMessage: false,
              senderID: firebaseAuth.currentUser?.uid,
            );
            final value = await messageRepository.sendMessageToAGroupChat(
              groupID: event.groupModel?.groupID,
              message: message,
            );
            log("Group message: $value");
          } else {
            message = MessageModel(
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
              receiverID: event.chatModel?.receiverID,
              senderID: event.chatModel?.senderID,
            );
            await messageRepository.sendMessage(
              chatId: chatID,
              message: message,
              receiverContactName: event.receiverContactName,
              receiverId: event.receiverContactName,
            );
          }
          MessageData.updateChatMessageDataOfUser(
              isGroup: event.isGroup,
              chatModel: event.chatModel,
              groupModel: event.groupModel,
              message: message);
          final messages = messageRepository.getAllMessages(
            isGroup: event.isGroup,
            groupModel: event.groupModel,
            chatId: chatID,
          );
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
              isGroup: event.isGroup,
              groupModel: event.groupModel,
              receiverContactName: event.receiverContactName,
              receiverID: event.receiverID,
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
      final String? chatID = event.chatModel?.chatID;
      if (chatID == null && !event.isGroup) {
        return null;
      }
      if (event.groupModel == null && event.isGroup) {
        return null;
      }
      final fileUrl = await messageRepository.sendAssetMessage(
        chatID: chatID,
        file: event.audioFile,
      );
      MessageModel message;
      if (event.isGroup) {
        message = MessageModel(
          message: fileUrl,
          messageType: MessageType.audio,
          messageTime: DateTime.now().toString(),
          messageStatus: MessageStatus.sent,
          isDeletedMessage: false,
          isEditedMessage: false,
          isPinnedMessage: false,
          isStarredMessage: false,
          senderID: firebaseAuth.currentUser?.uid,
        );
        final value = await messageRepository.sendMessageToAGroupChat(
          groupID: event.groupModel?.groupID,
          message: message,
        );
        log("Group message: $value");
      } else {
        message = MessageModel(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          message: fileUrl,
          messageType: MessageType.audio,
          messageTime: DateTime.now().toString(),
          messageStatus: MessageStatus.sent,
          isDeletedMessage: false,
          isEditedMessage: false,
          isPinnedMessage: false,
          isStarredMessage: false,
          receiverID: event.chatModel?.receiverID,
          senderID: event.chatModel?.senderID,
        );
        await messageRepository.sendMessage(
          chatId: chatID,
          message: message,
          receiverContactName: event.receiverContactName,
          receiverId: event.receiverContactName,
        );
      }
      MessageData.updateChatMessageDataOfUser(
        isGroup: event.isGroup,
        chatModel: event.chatModel,
        message: message,
        groupModel: event.groupModel,
      );
      final messages = messageRepository.getAllMessages(
        isGroup: event.isGroup,
        groupModel: event.groupModel,
        chatId: chatID,
      );
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
    final newAudioPlayingStates =
        Map<String, bool>.from(state.audioPlayingStates);
    newAudioPlayingStates[event.messageKey] = event.isPlaying;
    emit(state.copyWith(audioPlayingStates: newAudioPlayingStates));
  }

  FutureOr<void> _onAudioPlayerCompleted(
      AudioPlayerCompletedEvent event, Emitter<MessageState> emit) {
    final newAudioPositions = Map<String, Duration>.from(state.audioPositions);
    newAudioPositions[event.messageKey] = Duration.zero;
    final newAudioPlayingStates =
        Map<String, bool>.from(state.audioPlayingStates);
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
      if (chatID == null && !event.isGroup) {
        return null;
      }
      if (event.groupModel == null && event.isGroup) {
        return null;
      }
      MessageModel message;
      if (event.isGroup) {
        message = MessageModel(
          message: event.location,
          messageType: MessageType.location,
          messageTime: DateTime.now().toString(),
          messageStatus: MessageStatus.sent,
          isDeletedMessage: false,
          isEditedMessage: false,
          isPinnedMessage: false,
          isStarredMessage: false,
          senderID: firebaseAuth.currentUser?.uid,
        );
        final value = await messageRepository.sendMessageToAGroupChat(
          groupID: event.groupModel?.groupID,
          message: message,
        );
        log("Group message: $value");
      } else {
        message = MessageModel(
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
        await messageRepository.sendMessage(
          chatId: chatID,
          message: message,
          receiverContactName: event.receiverContactName,
          receiverId: event.receiverContactName,
        );
      }

      MessageData.updateChatMessageDataOfUser(
        isGroup: event.isGroup,
        chatModel: event.chatModel,
        message: message,
        groupModel: event.groupModel,
      );
      final messages = messageRepository.getAllMessages(
        isGroup: event.isGroup,
        groupModel: event.groupModel,
        chatId: chatID,
      );
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

  FutureOr<void> messageDeleteForEveryOneEvent(
      MessageDeleteForEveryOneEvent event, Emitter<MessageState> emit) async {
    try {
      final value = await messageRepository.deleteForEveryOne(
        messageID: event.messageID,
        isGroup: event.isGroup,
        chatModel: event.chatModel,
        groupModel: event.groupModel,
      );
      log(value.toString());
      emit(state.copyWith(messages: state.messages));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> messageDeleteForOne(
      MessageDeleteForOne event, Emitter<MessageState> emit) async {
    try {
      final value = await messageRepository.deleteMultipleMessageForOneUser(
        messageIdList: event.messageIdList,
        isGroup: event.isGroup,
        userID: event.userID,
        groupModel: event.groupModel,
        chatModel: event.chatModel,
      );
      for (var messageId in event.messageIdList) {
        if (event.context != null && event.context.mounted) {
          add(MessageSelectedEvent(
            messageId: messageId,
            context: event.context,
            isGroup: event.isGroup,
          ));
        }
      }
      log(value.toString());
      emit(state.copyWith(messages: state.messages));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> messageSelectedEvent(
      MessageSelectedEvent event, Emitter<MessageState> emit) {
    try {
      final updatedSelectedIds =
          Set<String>.from(state.selectedMessageIds as Iterable);
      if (updatedSelectedIds
          .contains(event.messageModel?.messageId ?? event.messageId)) {
        updatedSelectedIds
            .remove(event.messageModel?.messageId ?? event.messageId);
      } else {
        updatedSelectedIds
            .add(event.messageModel?.messageId ?? event.messageId ?? '');
      }

      MessageMethods.messageActionMethods(
        groupModel: event.groupModel,
        chatModel: event.chatModel,
        isGroup: event.isGroup,
        selectedMessagesId: updatedSelectedIds,
        context: event.context,
        message: event.messageModel,
      );
      emit(state.copyWith(
          selectedMessageIds: updatedSelectedIds,
          messagemodel: event.messageModel));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

  FutureOr<void> getReplyMessageEvent(
      GetReplyMessageEvent event, Emitter<MessageState> emit) {
    try {
      emit(state.copyWith(replyMessagemodel: event.repliedToMessage));
    } catch (e) {
      emit(MessageErrorState(message: e.toString()));
    }
  }

 FutureOr<void> unSelectEvent(UnSelectEvent event, Emitter<MessageState> emit) {
  if (state.selectedMessageIds != null) {
    final updatedSelectedIds = Set<String>.from(state.selectedMessageIds!);
    if (updatedSelectedIds.contains(event.messageId)) {
      updatedSelectedIds.remove(event.messageId);
      emit(state.copyWith(selectedMessageIds: updatedSelectedIds));
    }
  }
}


}
