import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

List<Widget> appBarIconsHome(
    {required bool isSearchIconNeeded,
    required ThemeData theme,
    required int currentIndex,
    required BuildContext context}) {
     final themeManager = Provider.of<ThemeManager>(context, listen: false);
  return [
    currentIndex == 0
        ? CircleAvatar(
          backgroundColor: theme.primaryColor,
          child: IconButton(
              onPressed: () {
                themeManager.changeTheme();
              },
              icon: Icon(
                Icons.dark_mode,
                size: 30.sp,
              ),
            ),
        )
        : zeroMeasureWidget,
    CommonIconButtonWidget(
      theme: theme,
      height: 30,
      width: 30,
      iconImage: "assets/camera.svg",
      onPressed: () {},
    ),
    isSearchIconNeeded
        ? CommonIconButtonWidget(
            theme: theme,
            height: 22,
            width: 22,
            iconImage: "assets/search.svg",
            onPressed: () {},
          )
        : zeroMeasureWidget,
    PopupMenuButton(
      onSelected: (value) {},
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
      color: theme.popupMenuTheme.color,
      iconColor: theme.colorScheme.onPrimary,
      iconSize: 26.sp,
      itemBuilder: (context) {
        if (currentIndex == 0) {
          return [
            const PopupMenuItem(child: Text("New group")),
            const PopupMenuItem(child: Text("New broadcast")),
            const PopupMenuItem(child: Text("Linked devices")),
            const PopupMenuItem(child: Text("Starred messages")),
            const PopupMenuItem(child: Text("Payments")),
            const PopupMenuItem(child: Text("Settings")),
          ];
        }
        if (currentIndex == 1 || currentIndex == 2) {
          return [
            const PopupMenuItem(child: Text("Settings")),
          ];
        }
        return [
          const PopupMenuItem(child: Text("Clear call log")),
          const PopupMenuItem(child: Text("Settings")),
        ];
      },
    ),
  ];
}
