import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/appbar_title_home.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/appbar_icons_home.dart';
import 'package:flutter/material.dart';

class GroupHomePage extends StatelessWidget {
  const GroupHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        automaticallyImplyLeading: false,
        title: const AppBarTitleHome(appBarTitle: "ChatBox"),
        actions: appBarIconsHome(
          theme: Theme.of(context),
          isSearchIconNeeded: false,
        ),
      ),
      body: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) => ChatListTileWidget(
          userName: "Group1",
          lastMessage: "lastMessage",
          isSeen: false,
          userProfileImage: "assets/appLogo.png",
          lastMessageArrivedTime: "10:00 am",
          notificationNUmber: 0,
          isNotificationCome: false,
          isGone: true,
          isMutedChat: false,
        ),
        separatorBuilder: (context, index) => kHeight5,
      ),
    );
  }
}
