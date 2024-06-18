import 'package:chatbox/core/enums/enums.dart';
import 'package:flutter/material.dart';

import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/widgets/chat_home/appbar_title_home.dart';
import 'package:chatbox/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/appbar_icons_home.dart';

class Chats {
  final bool isGone;
  final String userName;
  final String lastMessage;
  final bool isSeen;
  final String userProfileImage;
  final String lastMessageArrivedTime;
  final int notificationNUmber;
  final bool isNotificationCome;
  final bool isMutedChat;
  // message section
  final bool isTyping;
  final bool isVoiceRecoding;
  final bool isIncomingMessage;
  final bool isPhoto;
  final bool isAudio;
  final bool isDocument;
  final bool isRecordedAudio;
  final bool isContact;
  final bool isOutgoing;
  Chats({
    required this.isGone,
    required this.userName,
    required this.lastMessage,
    required this.isSeen,
    required this.userProfileImage,
    required this.lastMessageArrivedTime,
    required this.notificationNUmber,
    required this.isNotificationCome,
    required this.isMutedChat,
    required this.isTyping,
    required this.isVoiceRecoding,
    required this.isIncomingMessage,
    required this.isPhoto,
    required this.isAudio,
    required this.isDocument,
    required this.isRecordedAudio,
    required this.isContact,
    required this.isOutgoing,
  });
}

List<Chats> chats = [
  Chats(
    isOutgoing: false,
    isGone: true,
    userName: "userName",
    lastMessage: "lastMessage",
    isSeen: true,
    userProfileImage: "assets/photoLogo.png",
    lastMessageArrivedTime: "10:00",
    notificationNUmber: 0,
    isNotificationCome: false,
    isMutedChat: false,
    isTyping: true,
    isVoiceRecoding: false,
    isIncomingMessage: false,
    isPhoto: false,
    isAudio: false,
    isDocument: false,
    isRecordedAudio: false,
    isContact: false,
  ),
  Chats(
    isOutgoing: true,
    isGone: true,
    userName: "userName",
    lastMessage: "lastMessage",
    isSeen: false,
    userProfileImage: "assets/photoLogo.png",
    lastMessageArrivedTime: "10:00",
    notificationNUmber: 0,
    isNotificationCome: false,
    isMutedChat: false,
    isTyping: true,
    isVoiceRecoding: false,
    isIncomingMessage: false,
    isPhoto: false,
    isAudio: false,
    isDocument: false,
    isRecordedAudio: false,
    isContact: false,
  ),
  Chats(
    isOutgoing: false,
    isGone: true,
    userName: "userName",
    lastMessage: "lastMessage",
    isSeen: false,
    userProfileImage: "assets/photoLogo.png",
    lastMessageArrivedTime: "10:00",
    notificationNUmber: 0,
    isNotificationCome: false,
    isMutedChat: false,
    isTyping: false,
    isVoiceRecoding: true,
    isIncomingMessage: false,
    isPhoto: false,
    isAudio: false,
    isDocument: false,
    isRecordedAudio: false,
    isContact: false,
  ),
  Chats(
    isOutgoing: false,
    isGone: true,
    userName: "userName",
    lastMessage: "lastMessage",
    isSeen: false,
    userProfileImage: "assets/photoLogo.png",
    lastMessageArrivedTime: "10:00",
    notificationNUmber: 0,
    isNotificationCome: false,
    isMutedChat: false,
    isTyping: false,
    isVoiceRecoding: false,
    isIncomingMessage: true,
    isPhoto: false,
    isAudio: false,
    isDocument: false,
    isRecordedAudio: false,
    isContact: false,
  ),
  Chats(
    isOutgoing: false,
    isGone: true,
    userName: "userName",
    lastMessage: "lastMessage",
    isSeen: false,
    userProfileImage: "assets/photoLogo.png",
    lastMessageArrivedTime: "10:00",
    notificationNUmber: 0,
    isNotificationCome: false,
    isMutedChat: false,
    isTyping: false,
    isVoiceRecoding: false,
    isIncomingMessage: true,
    isPhoto: true,
    isAudio: false,
    isDocument: false,
    isRecordedAudio: false,
    isContact: false,
  ),
  Chats(
    isOutgoing: true,
    isGone: true,
    userName: "userName",
    lastMessage: "lastMessage",
    isSeen: false,
    userProfileImage: "assets/photoLogo.png",
    lastMessageArrivedTime: "10:00",
    notificationNUmber: 0,
    isNotificationCome: false,
    isMutedChat: false,
    isTyping: false,
    isVoiceRecoding: false,
    isIncomingMessage: false,
    isPhoto: true,
    isAudio: false,
    isDocument: false,
    isRecordedAudio: false,
    isContact: false,
  ),
  Chats(
    isOutgoing: true,
    isGone: true,
    userName: "userName",
    lastMessage: "lastMessage",
    isSeen: false,
    userProfileImage: "assets/photoLogo.png",
    lastMessageArrivedTime: "10:00",
    notificationNUmber: 0,
    isNotificationCome: false,
    isMutedChat: false,
    isTyping: false,
    isVoiceRecoding: false,
    isIncomingMessage: false,
    isPhoto: false,
    isAudio: true,
    isDocument: false,
    isRecordedAudio: false,
    isContact: false,
  ),
  Chats(
    isGone: true,
    isOutgoing: true,
    userName: "userName",
    lastMessage: "lastMessage",
    isSeen: false,
    userProfileImage: "assets/photoLogo.png",
    lastMessageArrivedTime: "10:00",
    notificationNUmber: 0,
    isNotificationCome: false,
    isMutedChat: false,
    isTyping: false,
    isVoiceRecoding: false,
    isIncomingMessage: false,
    isPhoto: false,
    isAudio: false,
    isDocument: true,
    isRecordedAudio: false,
    isContact: false,
  ),
  Chats(
    isGone: true,
    userName: "userName",
    lastMessage: "lastMessage",
    isSeen: false,
    userProfileImage: "assets/photoLogo.png",
    lastMessageArrivedTime: "10:00",
    notificationNUmber: 0,
    isNotificationCome: false,
    isMutedChat: true,
    isTyping: false,
    isVoiceRecoding: false,
    isOutgoing: false,
    isIncomingMessage: true,
    isPhoto: false,
    isAudio: false,
    isDocument: false,
    isRecordedAudio: true,
    isContact: false,
  ),
  Chats(
    isGone: true,
    userName: "userName",
    lastMessage: "lastMessage",
    isSeen: false,
    userProfileImage: "assets/photoLogo.png",
    lastMessageArrivedTime: "10:00",
    notificationNUmber: 0,
    isNotificationCome: false,
    isMutedChat: false,
    isTyping: false,
    isVoiceRecoding: false,
    isOutgoing: false,
    isIncomingMessage: true,
    isPhoto: false,
    isAudio: false,
    isDocument: false,
    isRecordedAudio: true,
    isContact: true,
  ),
];

class GroupHomePage extends StatelessWidget {
  const GroupHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(0),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final c = chats[index];
          return ChatListTileWidget(
            isGroup: true,
            isOutgoing: c.isOutgoing,
            userName: "Group1",
            lastMessage: "lastMessagednkanvkankdnv",
            isSeen: c.isSeen,
            userProfileImage: "assets/appLogo.png",
            lastMessageTime: "10:00",
            notificationCount: 10,
            isGone: c.isGone,
            isMutedChat: c.isMutedChat,
            // message
            isAudio: c.isAudio,
            isContact: c.isContact,
            isDocument: c.isDocument,
            isIncomingMessage: c.isIncomingMessage,
            isPhoto: c.isPhoto,
            isRecordedAudio: c.isRecordedAudio,
            isTyping: c.isTyping,
            isVoiceRecoding: c.isVoiceRecoding,
          );
        },
        separatorBuilder: (context, index) => kHeight5,
      ),
    );
  }
}
