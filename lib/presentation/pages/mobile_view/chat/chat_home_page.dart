import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:chatbox/presentation/widgets/chat_home/searchbar_chat_home.dart';
import 'package:flutter/material.dart';
class ChatHomePage extends StatelessWidget {
  const ChatHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SearchBarChatHome(),
            ),
            SliverList.separated(
              itemCount: 100,
              itemBuilder: (context, index) {
                return const ChatListTileWidget(
                  isGroup: false,
                  isOutgoing: true,
                  isMutedChat: true,
                  isGone: true,
                  isSeen: true,
                  lastMessage: "Hello how arxc j cjndjncan asncjandje you?",
                  lastMessageTime: "10:24",
                  notificationCount: 30,
                  userName: "Anonymous Person",
                  userProfileImage: "assets/appLogo.png",
                  // message
                  isAudio: false,
                  isContact: false,
                  isDocument: false,
                  isIncomingMessage: false,
                  isPhoto: false,
                  isRecordedAudio: false,
                  isTyping: false,
                  isVoiceRecoding: false,
                );
              },
              separatorBuilder: (context, index) => kHeight5,
            ),
          ],
        ),
      );
  }
}