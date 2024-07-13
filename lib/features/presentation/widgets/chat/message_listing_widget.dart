import 'dart:developer';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/widgets/chat/message_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

Widget messageListingWidget({
  required MessageState state,
  required ScrollController scrollController,
  required ChatModel chatModel,
  required AudioPlayer player,
  required Map<String, VideoPlayerController> videoControllers,
}) {
  return StreamBuilder<List<MessageModel>>(
      stream: state.messages,
      builder: (context, snapshot) {
        log("Inside stream builder");
        if (snapshot.data == null) {
          log("Snapshot message list data null");
          return zeroMeasureWidget;
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
            controller: scrollController,
            separatorBuilder: (context, index) => kHeight2,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              log("Inside listview builder");
              log(snapshot.data!.length.toString());
              final message = snapshot.data![index];
              if (message.messageType == MessageType.video &&
                  !videoControllers.containsKey(message.message)) {
                videoControllers[message.message!] =
                    VideoPlayerController.networkUrl(
                  Uri.parse(message.message!),
                )..initialize().then((_) {});
              }
              return MessageContainerWidget(
                chatModel: chatModel,
                message: snapshot.data![index],
                player: player,
                videoControllers: videoControllers,
              );
            });
      });
}
