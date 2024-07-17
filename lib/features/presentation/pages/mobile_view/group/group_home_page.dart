import 'package:flutter/material.dart';
class GroupHomePage extends StatelessWidget {
  const GroupHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ListView.separated(
      //   padding: const EdgeInsets.all(0),
      //   itemCount: chats.length,
      //   itemBuilder: (context, index) {
      //     final c = chats[index];
      //     return ChatListTileWidget(
      //       chatModel: const ChatModel(),
      //       messageStatus: MessageStatus.delivered,
      //       isGroup: true,
      //       isOutgoing: c.isOutgoing,
      //       userName: "Group1",
      //       lastMessage: "lastMessagednkanvkankdnv",
      //       isSeen: c.isSeen,
      //       userProfileImage: "",
      //       lastMessageTime: "10:00",
      //       notificationCount: 10,
      //       isGone: c.isGone,
      //       isMutedChat: c.isMutedChat,
      //       // message
      //       isAudio: c.isAudio,
      //       isContact: c.isContact,
      //       isDocument: c.isDocument,
      //       isIncomingMessage: c.isIncomingMessage,
      //       isPhoto: c.isPhoto,
      //       isRecordedAudio: c.isRecordedAudio,
      //       isTyping: c.isTyping,
      //       isVoiceRecoding: c.isVoiceRecoding,
      //     );
      //   },
      //   separatorBuilder: (context, index) => kHeight5,
      // ),
    );
  }
}
