import 'package:chatbox/config/theme/theme_constants.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/appbar_title_home.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/searchbar_chat_home.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/appbar_icons_home.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatHomePage extends StatelessWidget {
  ChatHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              surfaceTintColor: kTransparent,
              floating: true,
              pinned: false,
              snap: true,
              automaticallyImplyLeading: false,
              title: const AppBarTitleHome(appBarTitle: "ChatBox"),
              actions: appBarIconsHome(
                theme: Theme.of(context),
                isSearchIconNeeded: false,
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SearchBarChatHome(),
            ),
            SliverList.separated(
              itemCount: 100,
              itemBuilder: (context, index) {
                return const ChatListTileWidget(
                  isMutedChat: true,
                  isGone: true,
                  isNotificationCome: true,
                  isSeen: true,
                  lastMessage: "Hello how arxc j cjndjncan asncjandje you?",
                  lastMessageArrivedTime: "10:24",
                  notificationNUmber: 30,
                  userName: "Anonymous Person",
                  userProfileImage: "assets/appLogo.png",
                );
              },
              separatorBuilder: (context, index) => kHeight5,
            ),
          ],
        ),
      ),
    );
  }
}