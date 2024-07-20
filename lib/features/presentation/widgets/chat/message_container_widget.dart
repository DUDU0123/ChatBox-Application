import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/widgets/chat/contact_message_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/audio_message_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/different_message_widgets.dart';
import 'package:chatbox/features/presentation/widgets/chat/message_status_show_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

class MessageContainerWidget extends StatelessWidget {
  const MessageContainerWidget({
    super.key,
    required this.message,
    this.chatModel,
    this.groupModel,
    required this.videoControllers,
    required this.audioPlayers,
    required this.receiverID,
    required this.rootContext,required this.isGroup, required this.isIncomingMessage,
  });
  final MessageModel message;
  final ChatModel? chatModel;
  final GroupModel? groupModel;
  final Map<String, VideoPlayerController> videoControllers;
  final Map<String, AudioPlayer> audioPlayers;
  final String receiverID;
  final BuildContext rootContext;
  final bool isGroup;
  final bool isIncomingMessage;

  

  @override
  Widget build(BuildContext context) {
    if (message.message == null) {
      return zeroMeasureWidget;
    }

    bool isCurrentUserMessage;
    if (isGroup && groupModel != null) {
      isCurrentUserMessage = groupModel!.groupMembers!.contains(firebaseAuth.currentUser?.uid) &&
                             message.senderID == firebaseAuth.currentUser?.uid;
    } else {
      isCurrentUserMessage = firebaseAuth.currentUser?.uid == message.senderID;
    }

    groupModel?.groupMembers?.where((memberID)=> memberID!=firebaseAuth.currentUser?.uid);
    return Align(
      alignment: 
      // firebaseAuth.currentUser?.uid == message.receiverID
      //     ? Alignment.centerLeft
      //     : Alignment.centerRight,
      isCurrentUserMessage
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Stack(
        children: [
          message.messageType == MessageType.audio
              ? audioMessageWidget(
                  context: rootContext,
                  audioPlayers: audioPlayers,
                  message: message,
                )
              : Container(
                  height: message.messageType == MessageType.photo ||
                          message.messageType == MessageType.video
                      ? 250.h
                      : null,
                  width: message.message!.length > 20 ||
                          message.messageType == MessageType.contact
                      ? screenWidth(context: context) / 1.6
                      : screenWidth(context: context) / 2.6,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: message.messageType == MessageType.photo ||
                          message.messageType == MessageType.video
                      ? EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h)
                      : EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                          top: 10.h,
                          bottom: 15.h,
                        ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    gradient: message.messageType != MessageType.location
                        ? LinearGradient(
                            colors: [
                              lightLinearGradientColorOne,
                              lightLinearGradientColorTwo,
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              lightLinearGradientColorOne,
                              lightLinearGradientColorTwo,
                            ],
                          ),
                  ),
                  child: message.messageType == MessageType.text
                      ? textMessageWidget(message: message)
                      : message.messageType == MessageType.photo
                          ? photoMessageShowWidget(
                            isGroup: isGroup,groupModel: groupModel,
                              receiverID: receiverID,
                              message: message,
                              chatModel: chatModel,
                              context: context,
                            )
                          : videoControllers[message.message!] != null
                              ? videoMessageShowWidget(
                                isGroup: isGroup,groupModel: groupModel,
                                  receiverID: receiverID,
                                  chatModel: chatModel,
                                  videoControllers: videoControllers,
                                  context: context,
                                  message: message,
                                )
                              : message.messageType == MessageType.contact
                                  ? contactMessageWidget(
                                      context: context,
                                      message: message,
                                    )
                                  : message.messageType == MessageType.document
                                      ? documentMessageWidget(
                                          message: message,
                                        )
                                      : message.messageType ==
                                              MessageType.location
                                          ? locationMessageWidget(
                                              message: message,
                                            )
                                          : commonAnimationWidget(
                                              context: context,
                                              isTextNeeded: false,
                                            ),
                ),
          messageStatusShowWidget(
            isCurrentUserMessage: isCurrentUserMessage,
            message: message,
          ),
        ],
      ),
    );
  }
}
