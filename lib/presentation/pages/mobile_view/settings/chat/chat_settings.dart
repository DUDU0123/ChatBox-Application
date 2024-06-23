import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/presentation/pages/mobile_view/settings/chat/wallpaper_setpage.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:chatbox/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_butttons_common.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';
import 'package:chatbox/presentation/widgets/dialog_widgets/theme_set_dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatSettings extends StatelessWidget {
  const ChatSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(
          pageType: PageTypeEnum.settingsPage,
          appBarTitle: "Chats",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            commonListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const ThemeSetDialogBox();
                  },
                );
              },
              title: "Theme",
              subtitle: "System default",
              isSmallTitle: false,
              context: context,
              leading: SvgPicture.asset(
                theme,
                width: 30.w,
                height: 30.h,
                colorFilter: ColorFilter.mode(iconGreyColor, BlendMode.srcIn),
              ),
            ),
            kHeight10,
            commonListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WallpaperSetPage(),
                  ),
                );
              },
              title: "Wallpaper",
              isSmallTitle: false,
              context: context,
              leading: SvgPicture.asset(
                wallpaper,
                width: 30.w,
                height: 30.h,
                colorFilter: ColorFilter.mode(iconGreyColor, BlendMode.srcIn),
              ),
            ),
            kHeight10,
            commonListTile(
              onTap: () {
                normalDialogBoxWidget(
                  actionButtonName: "Clear chats",
                  context: context,
                  onPressed: () {
                     // method to clear all chats
                  },
                  subtitle:
                      "This will clear all the messages except starred messages",
                  title: "Clear all chats",
                );
              },
              title: "Clear all chats",
              isSmallTitle: false,
              context: context,
              leading: SvgPicture.asset(
                clearIcon,
                width: 30.w,
                height: 30.h,
                colorFilter: ColorFilter.mode(iconGreyColor, BlendMode.srcIn),
              ),
            ),
            kHeight10,
            commonListTile(
              onTap: () {
                normalDialogBoxWidget(
                  actionButtonName: "Delete chats",
                  context: context,
                  onPressed: () {
                    // method to delete all chats
                  },
                  subtitle: "This will delete all the messages in every chats.",
                  title: "Delete all chats",
                );
              },
              title: "Delete all chats",
              isSmallTitle: false,
              context: context,
              leading: SvgPicture.asset(
                deleteIcon2,
                width: 30.w,
                height: 30.h,
                colorFilter: ColorFilter.mode(iconGreyColor, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
