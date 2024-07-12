import 'dart:developer';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_actions_on_longpress_method.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/user_profile_show_dialog.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListTileWidget extends StatelessWidget {
  const ChatListTileWidget({
    super.key,
    required this.userName,
    this.lastMessage,
    this.userProfileImage,
    this.lastMessageTime,
    this.notificationCount,
    this.isSeen,
    this.isMutedChat,
    this.isGone,
    this.isTyping,
    this.isVoiceRecoding,
    this.isPhoto,
    this.isIncomingMessage,
    this.isDocument,
    this.isRecordedAudio,
    this.isAudio,
    this.isContact,
    this.isOutgoing,
    required this.isGroup,
    required this.messageStatus,
    required this.chatModel,
  });

  final String userName;
  final String? userProfileImage;
  final String? lastMessageTime;
  final int? notificationCount;
  final String? lastMessage;
  final bool? isMutedChat;
  final bool? isGone;
  final bool? isSeen;
  final bool? isTyping;
  final bool? isVoiceRecoding;
  final bool? isIncomingMessage;
  final bool? isPhoto;
  final bool? isAudio;
  final bool? isDocument;
  final bool? isRecordedAudio;
  final bool? isContact;
  final bool? isOutgoing;
  final bool isGroup;
  final ChatModel chatModel;
  final MessageStatus messageStatus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        chatTileActionsOnLongPressMethod(
          context: context,
          chatModel: chatModel,
        );
      },
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomPage(
                chatModel: chatModel,
                userName: userName,
                isGroup: isGroup,
                //isReadedMessage: isSeen,
              ),
            ),
          );
          if (chatModel.chatID != null) {
            context
                .read<MessageBloc>()
                .add(GetAllMessageEvent(chatId: chatModel.chatID!));
          }
        },
        leading: GestureDetector(
          onTap: () {
            log("Tapped image");
            userProfileShowDialog(
              context: context,
              userProfileImage: userProfileImage,
            );
          },
          child: buildProfileImage(
            userProfileImage: userProfileImage,
            context: context,
          ),
        ),
        title: buildUserName(userName: userName),
        subtitle: TextWidgetCommon(text: lastMessage??''),
        trailing: buildTrailing(
          context: context,
          notificationCount: notificationCount,
          isMutedChat: isMutedChat,
          lastMessageTime: lastMessageTime,
        ),
      ),
    );
  }
}
