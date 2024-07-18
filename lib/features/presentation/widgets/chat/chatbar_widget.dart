import 'dart:developer';
import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/emoji_select.dart';
import 'package:chatbox/core/utils/video_photo_from_camera_source_method.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_field_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatBarWidget extends StatefulWidget {
  ChatBarWidget({
    super.key,
    required this.messageController,
    required this.isImojiButtonClicked,
    required this.chatModel,
    required this.scrollController,
    required this.recorder,
    required this.receiverContactName,
  });
  final TextEditingController messageController;
  bool isImojiButtonClicked;
  final ScrollController scrollController;
  final FlutterSoundRecorder recorder;
  final ChatModel? chatModel;
  final String? receiverContactName;

  @override
  State<ChatBarWidget> createState() => _ChatBarWidgetState();
}

class _ChatBarWidgetState extends State<ChatBarWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.sp),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
        decoration: BoxDecoration(
          color: kTransparent,
          // image: DecorationImage(
          //     image: AssetImage(
          //       Provider.of<ThemeManager>(context).isDark
          //           ? bgImageDark
          //           : bgImageLight,
          //     ),
          //     fit: BoxFit.cover),
        ),
        width: screenWidth(context: context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10, left: 4.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      width: screenWidth(context: context) / 1.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.sp),
                        color: const Color.fromARGB(255, 39, 52, 78),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              // setState(() {
                              //   widget.isImojiButtonClicked =
                              //       !widget.isImojiButtonClicked;
                              // });
                            },
                            icon: SvgPicture.asset(
                              width: 25.w,
                              height: 25.h,
                              colorFilter: ColorFilter.mode(
                                  iconGreyColor, BlendMode.srcIn),
                              smileIcon,
                            ),
                          ),
                          Expanded(
                            child: TextFieldCommon(
                              style: fieldStyle(context: context).copyWith(
                                fontWeight: FontWeight.w400,
                                color: kWhite,
                              ),
                              onChanged: (value) {
                                log(widget.messageController.text);

                                context.read<MessageBloc>().add(
                                      MessageTypedEvent(
                                        textLength: value.length,
                                      ),
                                    );
                              },
                              hintText: "Type message...",
                              maxLines: 5,
                              controller: widget.messageController,
                              textAlign: TextAlign.start,
                              border: InputBorder.none,
                              cursorColor: buttonSmallTextColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<MessageBloc>()
                                      .add(AttachmentIconClickedEvent());
                                },
                                icon: Icon(
                                  Icons.attach_file,
                                  color: iconGreyColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  videoOrPhotoTakeFromCameraSourceMethod(
                                    receiverContactName:
                                        widget.receiverContactName,
                                    chatModel: widget.chatModel,
                                    context: context,
                                  );
                                },
                                icon: SvgPicture.asset(
                                  width: 25.w,
                                  height: 25.h,
                                  colorFilter: ColorFilter.mode(
                                    iconGreyColor,
                                    BlendMode.srcIn,
                                  ),
                                  cameraIcon,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //kWidth2,
                    Expanded(
                      child: Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: buttonSmallTextColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: IconButton(
                          onPressed: () async {
                            if (widget.messageController.text.isNotEmpty) {
                              sendMessage(
                                receiverContactName: widget.receiverContactName,
                                chatModel: widget.chatModel,
                                context: context,
                                messageController: widget.messageController,
                                scrollController: widget.scrollController,
                              );
                            } else {
                              context.read<MessageBloc>().add(
                                    AudioRecordToggleEvent(
                                      receiverID:
                                          widget.chatModel?.receiverID ?? '',
                                      receiverContactName:
                                          widget.receiverContactName ?? '',
                                      chatModel: widget.chatModel,
                                      recorder: widget.recorder,
                                    ),
                                  );
                            }
                          },
                          icon: BlocBuilder<MessageBloc, MessageState>(
                            builder: (context, state) {
                              return !state.isRecording!
                                  ? SvgPicture.asset(
                                      width: 24.w,
                                      height: 24.h,
                                      colorFilter: ColorFilter.mode(
                                          kBlack, BlendMode.srcIn),
                                      state.isTyped ??
                                              false ||
                                                  widget.messageController.text
                                                      .isNotEmpty
                                          ? sendIcon
                                          : microphoneFilled,
                                    )
                                  : Icon(
                                      Icons.stop,
                                      color: kBlack,
                                    );
                            },
                          ),
                        )),
                      ),
                    )
                  ],
                ),
              ),
              widget.isImojiButtonClicked
                  ? emojiSelect(textEditingController: widget.messageController)
                  : zeroMeasureWidget,
            ],
          ),
        ),
      ),
    );
  }
}

void sendMessage({
  required BuildContext context,
  required ChatModel? chatModel,
  required TextEditingController messageController,
  required ScrollController scrollController,
  required String? receiverContactName,
}) {
  MessageModel message = MessageModel(
    messageId: DateTime.now().millisecondsSinceEpoch.toString(),
    senderID: chatModel?.senderID,
    receiverID: chatModel?.receiverID,
    messageTime: DateTime.now().toString(),
    isPinnedMessage: false,
    isStarredMessage: false,
    isDeletedMessage: false,
    isEditedMessage: false,
    message: messageController.text,
    messageType: MessageType.text,
    messageStatus: MessageStatus.sent,
  );
  if (chatModel?.chatID != null) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    context.read<MessageBloc>().add(
          MessageSentEvent(
            currentUserId: firebaseAuth.currentUser?.uid ?? '',
            receiverContactName: receiverContactName ?? '',
            receiverID: chatModel?.receiverID ?? '',
            chatModel: chatModel,
            message: message,
          ),
        );
    messageController.clear();
  }
}
