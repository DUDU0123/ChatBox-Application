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
  required AudioPlayer player,
  required BuildContext context,
}) {
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
        )),
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
            size: 40.sp,
            color: kWhite,
          ),
        ),
        Expanded(
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: state.audioPosition.inSeconds.toDouble(),
                    max: state.audioDuration.inSeconds.toDouble(),
                    onChanged: (value) {
                      final newPosition = Duration(seconds: value.toInt());
                      player.seek(newPosition);
                      context
                          .read<MessageBloc>()
                          .add(AudioPlayerPositionChangedEvent(newPosition));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidgetCommon(
                          text: TimeProvider.formatDuration(state.audioPosition),
                          textColor: kWhite,
                          fontSize: 8.sp,
                        ),
                        TextWidgetCommon(
                          text: TimeProvider.formatDuration(state.audioDuration),
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
