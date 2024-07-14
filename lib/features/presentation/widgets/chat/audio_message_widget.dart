import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
Widget audioMessageWidget({
  required MessageModel message,
  required BuildContext context,
  required Map<String, AudioPlayer> audioPlayers,
}) {
  
   audioPlayers[message.message]?.durationStream.listen((duration) {
      if (duration != null) {
        context.read<MessageBloc>().add(AudioPlayerDurationChangedEvent(message.message!, duration));
      }
    });
   audioPlayers[message.message]?.positionStream.listen((position) {
      context.read<MessageBloc>().add(AudioPlayerPositionChangedEvent(message.message!, position));
    });
   audioPlayers[message.message]?.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        context.read<MessageBloc>().add(AudioPlayerCompletedEvent(message.message!));
      }
    });
  return Container(
    height: 75.h,
    width: screenWidth(context: context) / 1.26,
    padding: EdgeInsets.all(6.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.sp),
      gradient: LinearGradient(
        colors: [
          lightLinearGradientColorOne,
          lightLinearGradientColorTwo,
        ],
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: kBlack,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: () async {
            await audioPlayers[message.message]?.setUrl(message.message ?? '');

            final isPlaying = audioPlayers[message.message]?.playing ?? false;
            if (isPlaying) {
              await audioPlayers[message.message]?.pause();
              context.read<MessageBloc>().add(AudioPlayerPlayStateChangedEvent(message.message!, false));
            } else {
              await audioPlayers[message.message]!.play();
              context.read<MessageBloc>().add(AudioPlayerPlayStateChangedEvent(message.message!, true));
            }
          },
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              final isPlaying = state.audioPlayingStates[message.message] ?? false;
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
              final currentPosition = state.audioPositions[message.message] ?? Duration.zero;
              final duration = state.audioDurations[message.message] ?? Duration.zero;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: currentPosition.inSeconds.toDouble(),
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      final newPosition = Duration(seconds: value.toInt());
                      audioPlayers[message.message]?.seek(newPosition);
                      context.read<MessageBloc>().add(AudioPlayerPositionChangedEvent(message.message!, newPosition));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidgetCommon(
                          text: TimeProvider.formatDuration(currentPosition),
                          textColor: kWhite,
                          fontSize: 8.sp,
                        ),
                        TextWidgetCommon(
                          text: TimeProvider.formatDuration(duration),
                          textColor: kWhite,
                          fontSize: 8.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}


