import 'dart:developer';
import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/data_sources/user_data/user_data.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_actions_on_longpress_method.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/user_profile_show_dialog.dart';
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
    this.isMutedChat,
    this.isTyping,
    this.isVoiceRecoding,
    this.isIncomingMessage,
    required this.isGroup,
    required this.messageStatus,
    this.chatModel,
    this.groupModel,
    this.receiverID,
  });

  final String userName;
  final String? userProfileImage;
  final String? lastMessageTime;
  final int? notificationCount;
  final String? lastMessage;
  final bool? isMutedChat;
  final bool? isTyping;
  final bool? isVoiceRecoding;
  final bool? isIncomingMessage;
  final bool isGroup;
  final ChatModel? chatModel;
  final GroupModel? groupModel;
  final MessageStatus messageStatus;
  final String? receiverID;

  bool? getUserNetworkStatus({required String userID}) {
    bool? isOnline = false;

    UserData.getOneUserDataFromDataBaseAsStream(userId: userID).listen((user) {
      if (user == null) {
        return;
      }
      if (user.userNetworkStatus == null) {
        return;
      }
      if (user.userNetworkStatus!) {
        log("User Status: ${user.userNetworkStatus}");
        isOnline = user.userNetworkStatus;
      }
    });

    return isOnline;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (chatModel != null) {
          context.read<MessageBloc>().add(GetAllMessageEvent(
                chatId: chatModel?.chatID!,
                currentUserId: firebaseAuth.currentUser?.uid ?? '',
                receiverId: receiverID ?? "",
              ));
        }
      },
      onLongPress: () {
        if (chatModel != null) {
          chatTileActionsOnLongPressMethod(
            context: context,
            chatModel: chatModel!,
          );
        }
      },
      child: ListTile(
        onTap: () {
          if (chatModel != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoomPage(
                  chatModel: chatModel,
                  userName: userName,
                  isGroup: isGroup,
                ),
              ),
            );
          }

          if (groupModel != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoomPage(
                  groupModel: groupModel,
                  userName: userName,
                  isGroup: isGroup,
                ),
              ),
            );
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
        subtitle: buildSubtitle(
          messageStatus: messageStatus,
          isGroup: false,
          isIncomingMessage: isIncomingMessage,
          isTyping: false,
          isVoiceRecoding: false,
          lastMessage: lastMessage,
        ),
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
