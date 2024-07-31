import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/message_container_user_details.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/circle_image_show_prevent_error_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

Widget audioMessageWidget({
  required MessageModel message,
  required BuildContext context,
  required Map<String, AudioPlayer> audioPlayers,
  required GroupModel? groupModel,
  required bool isGroup,
  required void Function({required MessageModel message}) onSwipeMethod,
}) {
  audioPlayers[message.message]?.durationStream.listen((duration) {
    if (duration != null) {
      context
          .read<MessageBloc>()
          .add(AudioPlayerDurationChangedEvent(message.message!, duration));
    }
  });
  audioPlayers[message.message]?.positionStream.listen((position) {
    context
        .read<MessageBloc>()
        .add(AudioPlayerPositionChangedEvent(message.message!, position));
  });
  audioPlayers[message.message]?.playerStateStream.listen((playerState) {
    if (playerState.processingState == ProcessingState.completed) {
      context
          .read<MessageBloc>()
          .add(AudioPlayerCompletedEvent(message.message!));
    }
  });
  return Dismissible(
    confirmDismiss: (direction) async {
      await Future.delayed(const Duration(milliseconds: 2));
      onSwipeMethod(message: message);
      return false;
    },
    key: UniqueKey(),
    child: Container(
      // height: !isGroup?
      //  70.h
      //  :null,
      height: null,
      width: screenWidth(context: context) / 1.26,
      margin: EdgeInsets.symmetric(vertical: 3.h),
      padding: EdgeInsets.all(6.w),
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
        children: [
          isGroup
              ? messageContainerUserDetails(message: message)
              : zeroMeasureWidget,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<UserModel?>(
                  stream: message.senderID != null
                      ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                          userId: message.senderID!)
                      : null,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return nullImageReplaceWidget(
                          containerRadius: 30, context: context);
                    }
                    return circleImageShowPreventErrorWidget(
                      containerSize: 50,
                      image: snapshot.data!.userProfileImage!,
                    );
                  }),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () async {
                  await audioPlayers[message.message]
                      ?.setUrl(message.message ?? '');

                  final isPlaying =
                      audioPlayers[message.message]?.playing ?? false;
                  if (isPlaying) {
                    await audioPlayers[message.message]?.pause();
                    context.read<MessageBloc>().add(
                        AudioPlayerPlayStateChangedEvent(
                            message.message!, false));
                  } else {
                    await audioPlayers[message.message]!.play();
                    context.read<MessageBloc>().add(
                        AudioPlayerPlayStateChangedEvent(
                            message.message!, true));
                  }
                },
                child: BlocBuilder<MessageBloc, MessageState>(
                  builder: (context, state) {
                    final isPlaying =
                        state.audioPlayingStates[message.message] ?? false;
                    return Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40.sp,
                      color: kWhite,
                    );
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<MessageBloc, MessageState>(
                  builder: (context, state) {
                    final currentPosition =
                        state.audioPositions[message.message] ?? Duration.zero;
                    final duration =
                        state.audioDurations[message.message] ?? Duration.zero;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Slider(
                          value: currentPosition.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            final newPosition =
                                Duration(seconds: value.toInt());
                            audioPlayers[message.message]?.seek(newPosition);
                            context.read<MessageBloc>().add(
                                AudioPlayerPositionChangedEvent(
                                    message.message!, newPosition));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: TimeProvider.formatDuration(currentPosition) !=
                                  "00.00"
                              ? TextWidgetCommon(
                                  text: TimeProvider.formatDuration(
                                      currentPosition),
                                  textColor: kWhite,
                                  fontSize: 8.sp,
                                )
                              : TextWidgetCommon(
                                  text: TimeProvider.formatDuration(duration),
                                  textColor: kWhite,
                                  fontSize: 8.sp,
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
