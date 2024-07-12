import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/chat_asset_send_methods.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/data_sources/user_data/user_data.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/camera_photo_pick/asset_show_page.dart';
import 'package:chatbox/features/presentation/widgets/chat/attachment_list_container_vertical.dart';
import 'package:chatbox/features/presentation/widgets/chat/chatbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/divider_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({
    super.key,
    required this.userName,
    required this.isGroup,
    required this.chatModel,
  });
  final String userName;
  final ChatModel chatModel;
  final bool isGroup;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final Map<String, VideoPlayerController> videoControllers = {};
  final recorder = FlutterSoundRecorder();
  final player = AudioPlayer();
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<Duration?>? _positionSubscription;
  @override
  void initState() {
    super.initState();
    context
        .read<MessageBloc>()
        .add(GetAllMessageEvent(chatId: widget.chatModel.chatID ?? ''));
    // Listen for duration changes
    _durationSubscription = player.durationStream.listen((duration) {
      if (duration == null) {
        null;
      }
      context
          .read<MessageBloc>()
          .add(AudioPlayerDurationChangedEvent(duration!));
    });
    // Listen for position changes
    _positionSubscription = player.positionStream.listen((position) {
      context
          .read<MessageBloc>()
          .add(AudioPlayerPositionChangedEvent(position));
    });
  }

  @override
  void dispose() {
    videoControllers.forEach((key, controller) => controller.dispose());
    messageController.dispose();
    scrollController.dispose();
    recorder.closeRecorder();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    context
        .read<MessageBloc>()
        .add(GetAllMessageEvent(chatId: widget.chatModel.chatID ?? ''));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: StreamBuilder<UserModel?>(
            stream: UserData.getOneUserDataFromDataBaseAsStream(
                userId: widget.chatModel.receiverID ?? ''),
            builder: (context, snapshot) {
              
              return CommonAppBar(
                userProfileImage: widget.chatModel.receiverProfileImage,
                userStatus: snapshot.data != null
                    ? snapshot.data!.userNetworkStatus != null
                        ? snapshot.data!.userNetworkStatus!
                            ? 'Online'
                            : TimeProvider.getUserLastActiveTime(
                                givenTime:
                                    snapshot.data!.lastActiveTime.toString(),
                                context: context,
                              )
                        : TimeProvider.getUserLastActiveTime(
                            givenTime: snapshot.data!.lastActiveTime.toString(),
                            context: context,
                          )
                    : 'Offline',
                appBarTitle: widget.userName,
                pageType: widget.isGroup
                    ? PageTypeEnum.groupMessageInsidePage
                    : PageTypeEnum.oneToOneChatInsidePage,
              );
            }),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth(context: context),
            height: screenHeight(context: context),
            child: Image.asset(
                fit: BoxFit.cover,
                Provider.of<ThemeManager>(context).isDark ? bgImage : bgImage),
          ),
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
                      return commonErrorWidget();
                    }
                    if (state is MessageSucessState) {
                      return StreamBuilder<List<MessageModel>>(
                          stream: state.messages,
                          builder: (context, snapshot) {
                            log("Inside stream builder");
                            if (snapshot.data == null) {
                              return zeroMeasureWidget;
                            }
                            // state.messages.listen(
                            //     (v) => log("Lengthyy: ${v.length.toString()}"));
                            return ListView.separated(
                                controller: scrollController,
                                separatorBuilder: (context, index) => kHeight2,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  log("Inside listview builder");
                                  log(snapshot.data!.length.toString());
                                  final message = snapshot.data![index];
                                  if (message.messageType ==
                                          MessageType.video &&
                                      !videoControllers
                                          .containsKey(message.message)) {
                                    videoControllers[message.message!] =
                                        VideoPlayerController.networkUrl(
                                      Uri.parse(message.message!),
                                    )..initialize().then((_) {
                                            setState(() {});
                                          });
                                  }
                                  return MessageContainerWidget(
                                    chatModel: widget.chatModel,
                                    message: snapshot.data![index],
                                    player: player,
                                    videoControllers: videoControllers,
                                  );
                                });
                          });
                    }
                    return zeroMeasureWidget;
                  },
                ),
              ),
              ChatBarWidget(
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
                    chatModel: widget.chatModel,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessageContainerWidget extends StatelessWidget {
  const MessageContainerWidget({
    super.key,
    required this.message,
    required this.chatModel,
    required this.videoControllers,
    required this.player,
  });
  final MessageModel message;
  final ChatModel chatModel;
  final AudioPlayer player;
  final Map<String, VideoPlayerController> videoControllers;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: firebaseAuth.currentUser?.uid == message.receiverID
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Stack(
        children: [
          Container(
            height: message.messageType == MessageType.photo ||
                    message.messageType == MessageType.video
                ? 250.h
                : null,
            width: message.messageType != MessageType.audio
                ? message.message!.length <= 8
                    ? screenWidth(context: context) / 4
                    : screenWidth(context: context) / 1.6
                : screenWidth(context: context) / 1.6,
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
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
              gradient: message.messageType == MessageType.photo ||
                      message.messageType == MessageType.video
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
                        message: message,
                        chatModel: chatModel,
                        context: context,
                      )
                    : videoControllers[message.message!] != null
                        ? videoMessageShowWidget(
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
                            : message.messageType == MessageType.audio
                                ? audioMessageWidget(
                                    player: player,
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
            message: message,
          ),
        ],
      ),
    );
  }
}

Widget messageStatusShowWidget({
  required MessageModel message,
}) {
  return Positioned(
    bottom: 6.h,
    right: 18.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextWidgetCommon(
          text: DateProvider.take24HourTimeFromTimeStamp(
            timeStamp: message.messageTime.toString(),
          ),
          fontSize: 10.sp,
          textColor: kBlack,
        ),
        kWidth2,
        Icon(
          Icons.done,
          color: kBlack,
          size: 12.sp,
        ),
        kWidth2,
        Icon(
          Icons.push_pin_rounded,
          color: kBlack,
          size: 12.sp,
        ),
        kWidth2,
        Icon(
          Icons.star,
          color: kBlack,
          size: 12.sp,
        ),
        kWidth2,
        Icon(
          Icons.done_all,
          color: kBlack,
          size: 12.sp,
        )
      ],
    ),
  );
}

Widget locationMessageWidget({required MessageModel message}) {
  return Column(
    children: [
      TextButton(
        onPressed: () async {
          await canLaunchUrlString(message.message ?? '')
              ? await launchUrlString(message.message ?? '')
              : null;
        },
        child: TextWidgetCommon(
          text: "Open Location",
          textColor: kWhite,
          fontSize: 18.sp,
        ),
      ),
    ],
  );
}

Widget textMessageWidget({
  required MessageModel message,
}) {
  return TextWidgetCommon(
    fontSize: 16.sp,
    maxLines: null,
    text: message.message ?? '',
    textColor: kWhite,
  );
}

Widget documentMessageWidget({
  required MessageModel message,
}) {
  return GestureDetector(
    onTap: () {
      openDocument(url: message.message ?? '');
    },
    child: Row(
      children: [
        SvgPicture.asset(
          document,
          width: 30.w,
          height: 30.h,
          colorFilter: ColorFilter.mode(
            kWhite,
            BlendMode.srcIn,
          ),
        ),
        Expanded(
          child: TextWidgetCommon(
            overflow: TextOverflow.ellipsis,
            text: message.name ?? '',
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
        )
      ],
    ),
  );
}

Widget photoMessageShowWidget({
  required MessageModel message,
  required ChatModel chatModel,
  required BuildContext context,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.sp),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssetShowPage(
              messageType: MessageType.photo,
              chatID: chatModel.chatID ?? '',
              message: message,
            ),
          ),
        );
      },
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        placeholder: (context, url) => commonAnimationWidget(
          context: context,
          isTextNeeded: false,
        ),
        imageUrl: message.message ?? '',
      ),
    ),
  );
}

Widget videoMessageShowWidget({
  required MessageModel message,
  required ChatModel chatModel,
  required BuildContext context,
  required final Map<String, VideoPlayerController> videoControllers,
}) {
  return GestureDetector(
    onTap: () {
      log(
        videoControllers[message.message!]!.value.duration.toString(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssetShowPage(
            messageType: MessageType.video,
            chatID: chatModel.chatID ?? '',
            controllers: videoControllers,
            message: message,
          ),
        ),
      );
    },
    child: Stack(
      children: [
        VideoPlayer(
          videoControllers[message.message!]!,
        ),
        Positioned(
          bottom: 3,
          left: 5,
          child: TextWidgetCommon(
            text: DateProvider.parseDuration(
              videoControllers[message.message!]!.value.duration.toString(),
            ),
            textColor: kWhite,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 30.sp,
            backgroundColor: iconGreyColor.withOpacity(0.5),
            child: Icon(
              !videoControllers[message.message!]!.value.isPlaying
                  ? Icons.play_arrow
                  : Icons.pause,
              size: 30.sp,
              color: kBlack,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget contactMessageWidget(
    {required BuildContext context, required MessageModel message}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          commonProfileDefaultIconCircularCotainer(
            context: context,
            containerConstraint: 35,
          ),
          TextWidgetCommon(
            text: message.message ?? 'User',
            textColor: kBlack,
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
          ),
        ],
      ),
      kHeight10,
      CommonDivider(
        indent: 0,
        thickness: 1,
        color: kGrey.withOpacity(0.4),
      ),
      TextButton(
        onPressed: () {
          if (message.message != null) {
            addToContact(contactNumber: message.message!);
          }
        },
        child: TextWidgetCommon(
          text: "Add to contact",
          textColor: kWhite,
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
        ),
      ),
    ],
  );
}

Widget audioMessageWidget({
  required MessageModel message,
  required AudioPlayer player,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: kBlack,
          shape: BoxShape.circle,
        ),
      ),
      Expanded(
        child:
            BlocBuilder<MessageBloc, MessageState>(builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  message.message ?? '';
                  await player.setUrl(message.message ?? '');

                  if (player.playing) {
                    await player.pause();
                  } else {
                    await player.play();
                  }
                },
                child: Icon(
                  !player.playing ? Icons.play_arrow : Icons.pause,
                  size: 26.sp,
                  color: kWhite,
                ),
              ),
              // if (state.audioDuration != null && state.audioPosition != null)
              Column(
                children: [
                  Slider(
                    value: state.audioPosition.inSeconds.toDouble(),
                    max: state.audioDuration.inSeconds.toDouble(),
                    onChanged: (value) {
                      final newPosition = Duration(seconds: value.toInt());
                      // Seek to the new position
                      player.seek(newPosition);
                      // Update state if needed
                      context
                          .read<MessageBloc>()
                          .add(AudioPlayerPositionChangedEvent(newPosition));
                    },
                  ),
                  TextWidgetCommon(
                    text:
                        '${TimeProvider.formatDuration(state.audioPosition)} / ${TimeProvider.formatDuration(state.audioDuration)}',
                    textColor: kWhite,
                    fontSize: 12.sp,
                  )
                ],
              ),
            ],
          );
        }),
      ),
    ],
  );
}
