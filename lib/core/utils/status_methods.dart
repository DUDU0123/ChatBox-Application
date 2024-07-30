import 'dart:developer';
import 'dart:io';

import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/data/models/status_model/uploaded_status_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/bloc/status/status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusMethods {
  // method for upload status
  static Future<StatusModel> newStatusUploadMethod({
    File? fileToShow,
    String? fileCaption,
    String? statusDuration,
    required StatusType statusType,
    StatusModel? currentStatusModel,
    String? statusTextContent,
    Color? textStatusBgColor,
  }) async {
    // log(currentStatusModel.toString());
    String statusContentUrl = '';
    if (fileToShow != null && fileToShow != File('')) {
      statusContentUrl = await CommonDBFunctions.saveUserFileToDataBaseStorage(
        ref: "users_statuses/${firebaseAuth.currentUser?.uid}",
        file: fileToShow,
      );
    }

    UploadedStatusModel uploadedStatusModel = UploadedStatusModel(
      uploadedStatusId: DateTime.now().millisecondsSinceEpoch.toString(),
      statusCaption: fileCaption,
      statusUploadedTime: DateTime.now().toString(),
      isViewedStatus: false,
      statusDuration: statusDuration,
      statusType: statusType,
      textStatusBgColor: textStatusBgColor,
      statusContent:
          statusContentUrl.isNotEmpty ? statusContentUrl : statusTextContent,
    );
    print("This is uploaded ${uploadedStatusModel}");
    List<UploadedStatusModel> uploadedStatusList =
        currentStatusModel?.statusList ?? [];
    uploadedStatusList.add(uploadedStatusModel);

    log("Uploaded STTATUS List: $uploadedStatusList");

    // Create or update StatusModel
    StatusModel statusModel = StatusModel(
      statusUploaderId: firebaseAuth.currentUser?.uid ?? '',
      statusList: uploadedStatusList,
    );

    // If currentStatusModel is not null, copy its other fields (if any)
    if (currentStatusModel != null) {
      log("I m indide");
      statusModel = currentStatusModel.copyWith(
        statusList: uploadedStatusList,
      );
    }
    print("This is status after edit ${statusModel}");
    return statusModel;
  }

  static void shareStatusToAnyChat(
      {required List<ContactModel>? selectedContactList,
      required UploadedStatusModel? uploadedStatusModel,
      required BuildContext context}) async {
    for (var contact in selectedContactList!) {
      if (contact.chatBoxUserId != null && firebaseAuth.currentUser != null) {
        final ChatModel? chatModel =
            await CommonDBFunctions.getChatModel(receiverID: contact.chatBoxUserId!);
        final UserModel? receiverModel =
            await CommonDBFunctions.getOneUserDataFromDBFuture(
                userId: contact.chatBoxUserId);
        final MessageModel message = MessageModel(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          message: uploadedStatusModel?.statusContent,
          isDeletedMessage: false,
          isEditedMessage: false,
          isPinnedMessage: false,
          isStarredMessage: false,
          messageStatus: MessageStatus.sent,
          messageTime: DateTime.now().toString(),
          messageType: uploadedStatusModel?.statusType == StatusType.video
              ? MessageType.video
              : uploadedStatusModel?.statusType == StatusType.image
                  ? MessageType.photo
                  : MessageType.text,
          receiverID: contact.chatBoxUserId,
          senderID: firebaseAuth.currentUser?.uid,
        );
        context.read<MessageBloc>().add(MessageSentEvent(
              chatModel: chatModel,
              receiverID: contact.chatBoxUserId!,
              currentUserId: firebaseAuth.currentUser!.uid,
              receiverContactName: receiverModel?.contactName ??
                  receiverModel?.userName ??
                  receiverModel?.phoneNumber ??
                  '',
              message: message,
              isGroup: false,
            ));
      }
    }
  }
}


