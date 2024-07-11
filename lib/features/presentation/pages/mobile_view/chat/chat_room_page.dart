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
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/camera_photo_pick/asset_show_page.dart';
import 'package:chatbox/features/presentation/widgets/chat/attachment_list_container_vertical.dart';
import 'package:chatbox/features/presentation/widgets/chat/chatbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/divider_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final Map<String, VideoPlayerController> _videoControllers = {};
  final recorder = FlutterSoundRecorder();
  final player = AudioPlayer();

  @override
  void initState() {
    // initRecorder();
    super.initState();
  }


  @override
  void dispose() {
    _videoControllers.forEach((key, controller) => controller.dispose());
    messageController.dispose();
    scrollController.dispose();
    recorder.closeRecorder();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    context
        .read<MessageBloc>()
        .add(GetAllMessageEvent(chatId: widget.chatModel.chatID ?? ''));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CommonAppBar(
          userProfileImage: widget.chatModel.receiverProfileImage,
          userStatus: "Online",
          appBarTitle: widget.userName,
          pageType: widget.isGroup
              ? PageTypeEnum.groupMessageInsidePage
              : PageTypeEnum.oneToOneChatInsidePage,
        ),
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
                      return const Center(
                        child: TextWidgetCommon(text: "Something went wrong"),
                      );
                    }
                    if (state is MessageSucessState) {
                      return StreamBuilder<List<MessageModel>>(
                          stream: state.messages,
                          builder: (context, snapshot) {
                            log("Inside stream builder");
                            if (snapshot.data == null) {
                              return zeroMeasureWidget;
                            }
                            state.messages.listen(
                                (v) => log("Lengthyy: ${v.length.toString()}"));
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
                                      !_videoControllers
                                          .containsKey(message.message)) {
                                    _videoControllers[message.message!] =
                                        VideoPlayerController.networkUrl(
                                      Uri.parse(message.message!),
                                    )..initialize().then((_) {
                                            setState(() {});
                                          });
                                  }

                                  return Align(
                                    alignment: firebaseAuth.currentUser?.uid ==
                                            snapshot.data?[index].receiverID
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: message.messageType ==
                                                      MessageType.photo ||
                                                  message.messageType ==
                                                      MessageType.video
                                              ? 250.h
                                              : null,
                                          width: message.message!.length <= 8
                                              ? screenWidth(context: context) /
                                                  4
                                              : screenWidth(context: context) /
                                                  1.6,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 4.h),
                                          padding: message.messageType ==
                                                      MessageType.photo ||
                                                  message.messageType ==
                                                      MessageType.video
                                              ? EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 5.h)
                                              : EdgeInsets.only(
                                                  left: 10.w,
                                                  right: 10.w,
                                                  top: 10.h,
                                                  bottom: 15.h,
                                                ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.sp),
                                            gradient: message.messageType ==
                                                        MessageType.photo ||
                                                    message.messageType ==
                                                        MessageType.video
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
                                          child: message.messageType ==
                                                  MessageType.text
                                              ? TextWidgetCommon(
                                                  fontSize: 16.sp,
                                                  maxLines: null,
                                                  text: message.message ?? '',
                                                  textColor: kWhite,
                                                )
                                              : message.messageType ==
                                                      MessageType.photo
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.sp),
                                                      child: CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              commonAnimationWidget(
                                                                  context:
                                                                      context,
                                                                  isTextNeeded:
                                                                      false),
                                                          imageUrl:
                                                              message.message ??
                                                                  ''),
                                                    )
                                                  : _videoControllers[message
                                                              .message!] !=
                                                          null
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            log(
                                                              _videoControllers[
                                                                      message
                                                                          .message!]!
                                                                  .value
                                                                  .duration
                                                                  .toString(),
                                                            );
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AssetShowPage(
                                                                  chatID: widget
                                                                          .chatModel
                                                                          .chatID ??
                                                                      '',
                                                                  controllers:
                                                                      _videoControllers,
                                                                  message:
                                                                      message,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Stack(
                                                            children: [
                                                              VideoPlayer(
                                                                _videoControllers[
                                                                    message
                                                                        .message!]!,
                                                              ),
                                                              Positioned(
                                                                bottom: 3,
                                                                left: 5,
                                                                child:
                                                                    TextWidgetCommon(
                                                                  text: DateProvider
                                                                      .parseDuration(
                                                                    _videoControllers[
                                                                            message.message!]!
                                                                        .value
                                                                        .duration
                                                                        .toString(),
                                                                  ),
                                                                  textColor:
                                                                      kWhite,
                                                                  fontSize:
                                                                      10.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 30.sp,
                                                                  backgroundColor:
                                                                      iconGreyColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                  child: Icon(
                                                                    !_videoControllers[message.message!]!
                                                                            .value
                                                                            .isPlaying
                                                                        ? Icons
                                                                            .play_arrow
                                                                        : Icons
                                                                            .pause,
                                                                    size: 30.sp,
                                                                    color:
                                                                        kBlack,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : message.messageType ==
                                                              MessageType
                                                                  .contact
                                                          ? Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    commonProfileDefaultIconCircularCotainer(
                                                                      context:
                                                                          context,
                                                                      containerConstraint:
                                                                          35,
                                                                    ),
                                                                    TextWidgetCommon(
                                                                      text: message
                                                                              .message ??
                                                                          'User',
                                                                      textColor:
                                                                          kBlack,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          18.sp,
                                                                    ),
                                                                  ],
                                                                ),
                                                                kHeight10,
                                                                CommonDivider(
                                                                  indent: 0,
                                                                  thickness: 1,
                                                                  color: kGrey
                                                                      .withOpacity(
                                                                          0.4),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (message
                                                                            .message !=
                                                                        null) {
                                                                      addToContact(
                                                                          contactNumber:
                                                                              message.message!);
                                                                    }
                                                                  },
                                                                  child:
                                                                      TextWidgetCommon(
                                                                    text:
                                                                        "Add to contact",
                                                                    textColor:
                                                                        kWhite,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        15.sp,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : message.messageType ==
                                                                  MessageType
                                                                      .audio
                                                              ? SizedBox(
                                                                height: 40.h,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      // Container(
                                                                      //   width:
                                                                      //       200.w,
                                                                      //   height:
                                                                      //       200.h,
                                                                      //   decoration:
                                                                      //       BoxDecoration(
                                                                      //     color:
                                                                      //         kBlack,
                                                                      //     shape: BoxShape
                                                                      //         .circle,
                                                                      //   ),
                                                                      // ),
                                                                      CircleAvatar(radius: 40.sp,),
                                                                      IconButton(
                                                                        onPressed:
                                                                            () async{
                                                                              message.message??'';
                                                                              await player.setUrl(message.message??'');
                                                                              await player.play();
                                                                            },
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .play_arrow,
                                                                          size: 26
                                                                              .sp,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                              )
                                                              : message.messageType ==
                                                                      MessageType
                                                                          .document
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        openDocument(
                                                                            url:
                                                                                message.message ?? '');
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SvgPicture
                                                                              .asset(
                                                                            document,
                                                                            width:
                                                                                30.w,
                                                                            height:
                                                                                30.h,
                                                                            colorFilter:
                                                                                ColorFilter.mode(
                                                                              kWhite,
                                                                              BlendMode.srcIn,
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                TextWidgetCommon(
                                                                              overflow: TextOverflow.ellipsis,
                                                                              text: message.name ?? '',
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 16.sp,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : message.messageType ==
                                                                          MessageType
                                                                              .location
                                                                      ? Column(
                                                                          children: [],
                                                                        )
                                                                      : commonAnimationWidget(
                                                                          context:
                                                                              context,
                                                                          isTextNeeded:
                                                                              false,
                                                                        ),
                                        ),
                                        Positioned(
                                          bottom: 6.h,
                                          right: 18.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextWidgetCommon(
                                                text: DateProvider
                                                    .take24HourTimeFromTimeStamp(
                                                  timeStamp: snapshot
                                                      .data![index].messageTime
                                                      .toString(),
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
                                        )
                                      ],
                                    ),
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
