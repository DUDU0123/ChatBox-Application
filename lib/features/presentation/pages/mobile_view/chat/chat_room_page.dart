import 'dart:async';
import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/data_sources/chat_data/chat_data.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/widgets/chat/chat_room_appbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/message_listing_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/attachment_list_container_vertical.dart';
import 'package:chatbox/features/presentation/widgets/chat/chat_room_bg_image_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/chatbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/message_page_date_show_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({
    super.key,
    required this.userName,
    required this.isGroup,
    this.chatModel,
    this.groupModel,
    this.receiverID,
  });
  final String userName;
  final ChatModel? chatModel;
  final GroupModel? groupModel;
  final bool isGroup;
  final String? receiverID;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final Map<String, VideoPlayerController> videoControllers = {};
  final Map<String, AudioPlayer> audioPlayers = {};
  final recorder = FlutterSoundRecorder();
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<Duration?>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    !widget.isGroup
        ? CommonDBFunctions.updateChatOpenStatus(
            widget.chatModel?.receiverID ?? '',
            widget.chatModel?.chatID ?? '',
            true)
        : null;
  }

  @override
  void dispose() {
    videoControllers.forEach((key, controller) => controller.dispose());
    audioPlayers.forEach((key, controller) => controller.dispose());
    messageController.dispose();
    scrollController.dispose();
    recorder.closeRecorder();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    !widget.isGroup
        ? CommonDBFunctions.updateChatOpenStatus(
            widget.chatModel?.receiverID ?? '',
            widget.chatModel?.chatID ?? '',
            false)
        : null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ChatData.listenToChatDocument(widget.chatModel?.senderID??'', widget.chatModel?.chatID??'');

    context.read<MessageBloc>().add(GetAllMessageEvent(
          isGroup: widget.isGroup,
          groupModel: widget.groupModel,
          currentUserId: firebaseAuth.currentUser?.uid ?? '',
          receiverId: widget.receiverID ?? '',
          chatId: widget.chatModel?.chatID ?? "",
        ));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: !widget.isGroup
            ? oneToOneChatAppBarWidget(
                context: context,
                receiverID: widget.receiverID ?? "",
                chatModel: widget.chatModel,
                isGroup: false,
                userName: widget.userName,
              )
            : groupChatAppBarWidget(
                groupModel: widget.groupModel,
                isGroup: true,
                context: context,
              ),
      ),
      body: Stack(
        children: [
          chatRoomBackgroundImageWidget(context),
          Column(
            children: [
              Expanded(
                child: BlocBuilder<MessageBloc, MessageState>(
                  builder: (context, state) {
                    if (state is MessageLoadingState) {
                      return commonAnimationWidget(
                        context: context,
                        isTextNeeded: false,
                        lottie: settingsLottie,
                      );
                    }
                    if (state is MessageErrorState) {
                      return commonErrorWidget(message: state.message);
                    }
                    return messageListingWidget(
                      rootContext: context,
                      isGroup: widget.isGroup,
                      receiverID: widget.receiverID,
                      chatModel: widget.chatModel,
                      audioPlayers: audioPlayers,
                      scrollController: scrollController,
                      videoControllers: videoControllers,
                      state: state,
                    );
                  },
                ),
              ),
              ChatBarWidget(
                isGroup: widget.isGroup,
                groupModel: widget.groupModel,
                receiverContactName: widget.userName,
                recorder: recorder,
                scrollController: scrollController,
                chatModel: widget.chatModel,
                isImojiButtonClicked: false,
                messageController: messageController,
              ),
            ],
          ),
          Positioned(
            bottom: 60.h,
            right: screenWidth(context: context) / 3.3,
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.isAttachmentListOpened ?? false,
                  replacement: zeroMeasureWidget,
                  child: AttachmentListContainerVertical(
                    isGroup: widget.isGroup,
                    groupModel: widget.groupModel,
                    receverContactName: widget.userName,
                    chatModel: widget.chatModel,
                  ),
                );
              },
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state.messageDate == null) {
                    return zeroMeasureWidget;
                  }
                  if (state.messageDate!.isEmpty) {
                    return zeroMeasureWidget;
                  }
                  return MessagePageDateShowWidget(
                    date: state.messageDate!,
                  );
                },
              ))
        ],
      ),
    );
  }
}
