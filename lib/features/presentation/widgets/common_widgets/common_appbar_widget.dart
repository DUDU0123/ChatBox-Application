import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/enums/enums.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CommonAppBar extends StatelessWidget {
  const CommonAppBar({
    super.key,
    required this.pageType, required this.appBarTitle,
  });
  final PageTypeEnum pageType;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: TextWidgetCommon(text: appBarTitle,),
      actions: !(pageType==PageTypeEnum.settingsPage)?[
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            videoCall,
            width: 30.w,
            height: 30.h,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.onPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            call,
            width: 30.w,
            height: 23.h,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.onPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
        PopupMenuButton(
          onSelected: (value) {},
          itemBuilder: (context) {
            if (pageType == PageTypeEnum.oneToOneChatInsidePage) {
              return [
                const PopupMenuItem(child: Text("View contact")),
                const PopupMenuItem(child: Text("Media,links and docs")),
                const PopupMenuItem(child: Text("Search")),
                const PopupMenuItem(child: Text("Mute notifications")),
                const PopupMenuItem(child: Text("Wallpaper")),
                const PopupMenuItem(child: Text("Clear chat")),
                const PopupMenuItem(child: Text("Report")),
                const PopupMenuItem(child: Text("Block")),
              ];
            }
            if (pageType == PageTypeEnum.groupMessageInsidePage) {
              return [
                const PopupMenuItem(child: Text("Group info")),
                const PopupMenuItem(child: Text("Group media")),
                const PopupMenuItem(child: Text("Search")),
                const PopupMenuItem(child: Text("Mute notifications")),
                const PopupMenuItem(child: Text("Wallpaper")),
                const PopupMenuItem(child: Text("Clear chat")),
              ];
            }
            // if (pageType == PageTypeEnum.broadCastMessageInsidePage)
            return [
              const PopupMenuItem(child: Text("Broadcast list info")),
              const PopupMenuItem(child: Text("Broadcast list media")),
              const PopupMenuItem(child: Text("Search")),
              const PopupMenuItem(child: Text("Wallpaper")),
              const PopupMenuItem(child: Text("Clear chat")),
            ];
          },
        )
      ]:[],
    );
  }
}
