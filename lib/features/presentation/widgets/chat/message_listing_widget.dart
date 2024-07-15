import 'dart:developer';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/widgets/chat/message_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
Widget messageListingWidget({
  required MessageState state,
  required ScrollController scrollController,
  required ChatModel? chatModel,
  required String receiverID,
  required Map<String, AudioPlayer> audioPlayers,
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
          if (message.messageType == MessageType.audio &&
              !audioPlayers.containsKey(message.message)) {
            final player = AudioPlayer();
            audioPlayers[message.message!] = player;

            player.durationStream.listen((duration) {
              if (duration != null) {
                context.read<MessageBloc>().add(AudioPlayerDurationChangedEvent(message.message!, duration));
              }
            });
            player.positionStream.listen((position) {
              context.read<MessageBloc>().add(AudioPlayerPositionChangedEvent(message.message!, position));
            });
            player.playingStream.listen((isPlaying) {
              context.read<MessageBloc>().add(AudioPlayerPlayStateChangedEvent(message.message!, isPlaying));
            });
          }
          return MessageContainerWidget(
            receiverID:receiverID ,
            chatModel: chatModel,
            message: message,
            audioPlayers: audioPlayers,
            videoControllers: videoControllers,
          );
        },
      );
    },
  );
}
