import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class AssetShowPage extends StatefulWidget {
  const AssetShowPage({
    super.key,
    required this.controllers,
    required this.message,
    required this.chatID,
  });
  final Map<String, VideoPlayerController> controllers;
  final MessageModel message;
  final String chatID;

  @override
  _AssetShowPageState createState() => _AssetShowPageState();
}

class _AssetShowPageState extends State<AssetShowPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controllers[widget.message.message!]!;
    _controller.addListener(_videoPlayerListener);
  }

  void _videoPlayerListener() {
    if (_controller.value.position == _controller.value.duration) {
      context.read<MessageBloc>().add(VideoMessageCompleteEvent());
    } else if (_controller.value.isPlaying) {
      context.read<MessageBloc>().add(VideoMessagePlayEvent());
    } else {
      context.read<MessageBloc>().add(VideoMessagePauseEvent());
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoPlayerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            
            Navigator.pop(context);
            
            context.read<MessageBloc>().add(
                  GetAllMessageEvent(
                    chatId: widget.chatID,
                  ),
                );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Stack(
        children: [
          VideoPlayer(_controller),
          Align(
            alignment: Alignment.center,
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                IconData icon;
                if (_controller.value.position == _controller.value.duration) {
                  icon = Icons.play_arrow;
                } else {
                  icon = _controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow;
                }

                return GestureDetector(
                  onTap: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                      context.read<MessageBloc>().add(VideoMessagePauseEvent());
                    } else {
                      _controller.play();
                      context.read<MessageBloc>().add(VideoMessagePlayEvent());
                    }
                  },
                  child: CircleAvatar(
                    radius: 30.sp,
                    backgroundColor: iconGreyColor.withOpacity(0.5),
                    child: Icon(
                      icon,
                      size: 30.sp,
                      color: kBlack,
                    ),
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
