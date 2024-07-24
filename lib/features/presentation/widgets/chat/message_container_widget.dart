import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/widgets/chat/contact_message_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/audio_message_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/different_message_widgets.dart';
import 'package:chatbox/features/presentation/widgets/chat/message_status_show_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
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
    required this.rootContext,
    required this.isGroup,
  });
  final MessageModel message;
  final ChatModel? chatModel;
  final GroupModel? groupModel;
  final Map<String, VideoPlayerController> videoControllers;
  final Map<String, AudioPlayer> audioPlayers;
  final String receiverID;
  final BuildContext rootContext;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    if (message.message == null) {
      return zeroMeasureWidget;
    }
    return Align(
      alignment:
          // firebaseAuth.currentUser?.uid == message.receiverID
          //     ? Alignment.centerLeft
          //     : Alignment.centerRight,
          checkIsIncomingMessage(
        isGroup: isGroup,
        message: message,
        groupModel: groupModel,
      )
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
                  // width: message.message!.length > 20 ||
                  //         message.messageType == MessageType.contact
                  //     ? screenWidth(context: context) / 1.6
                  //     : screenWidth(context: context) / 2.6,
                  width: isGroup? screenWidth(context: context) / 1.8: message.message!.length>20?screenWidth(context: context)/1.8:message.message!.length<10?90.w:null,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: message.messageType == MessageType.photo ||
                          message.messageType == MessageType.video
                      ? EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h)
                      : EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                          top:isGroup? 5.h:10.h,
                          bottom: 15.h,
                        ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    gradient: checkIsIncomingMessage(
                      isGroup: isGroup,
                      message: message,
                      groupModel: groupModel,
                    )
                        ? LinearGradient(
                            colors: [
                              // lightLinearGradientColorOne,
                              // lightLinearGradientColorTwo,
                              darkSwitchColor, lightLinearGradientColorTwo,
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              kBlack,
                              darkSwitchColor,
                            ],
                          ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     isGroup? StreamBuilder<UserModel?>(
                       stream: CommonDBFunctions.getOneUserDataFromDataBaseAsStream(userId: firebaseAuth.currentUser!.uid),
                       builder: (context, snapshot) {
                        if (snapshot.data==null) {
                          return zeroMeasureWidget;
                        }
                        final contactName = snapshot.data?.contactName;
                        String prefix = '';
                        if (contactName==null || contactName.isEmpty) {
                          prefix = '~';
                        }
                         return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextWidgetCommon(
                                  text: "$prefix${snapshot.data?.contactName??snapshot.data!.userName??''}",
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10.sp,
                                ),
                              ),
                              kWidth2,
                              TextWidgetCommon(
                                text: snapshot.data?.phoneNumber??"",
                                fontSize: 10.sp,
                              )
                            ],
                          );
                       }
                     ):zeroMeasureWidget,
                      isGroup? kHeight5:zeroMeasureWidget,
                      message.messageType == MessageType.text
                          ? textMessageWidget(message: message)
                          : message.messageType == MessageType.photo
                              ? photoMessageShowWidget(
                                  isGroup: isGroup,
                                  groupModel: groupModel,
                                  receiverID: receiverID,
                                  message: message,
                                  chatModel: chatModel,
                                  context: context,
                                )
                              : videoControllers[message.message!] != null
                                  ? videoMessageShowWidget(
                                      isGroup: isGroup,
                                      groupModel: groupModel,
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
                                      : message.messageType ==
                                              MessageType.document
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
                    ],
                  ),
                ),
          messageStatusShowWidget(
            isCurrentUserMessage: checkIsIncomingMessage(
              isGroup: isGroup,
              message: message,
              groupModel: groupModel,
            ),
            message: message,
          ),
        ],
      ),
    );
  }
}
