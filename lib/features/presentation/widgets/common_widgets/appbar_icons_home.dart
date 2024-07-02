import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/select_contact_to_chat.dart';
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
    currentIndex == 0
        ? addChatButtonHome(
            theme: theme,
            onTap: () {
              context.read<ContactBloc>().add(GetContactsEvent());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectContactToChat(),
                ),
              );
            },
          )
        : zeroMeasureWidget,
    cameraButtonMainPage(
      theme: theme,
      onPressed: () {},
    ),
    isSearchIconNeeded
        ? searchButton(
            theme: theme,
            onPressed: () {},
          )
        : zeroMeasureWidget,
    PopupMenuButton(
      onSelected: (value) {},
      itemBuilder: (context) {
        if (currentIndex == 0) {
          return [
            PopupMenuItem(
              child: const Text("New group"),
              onTap: () {},
            ),
            PopupMenuItem(
              child: const Text("New broadcast"),
              onTap: () {},
            ),
            PopupMenuItem(
              child: const Text("Linked devices"),
              onTap: () {},
            ),
            PopupMenuItem(
              child: const Text("Starred messages"),
              onTap: () {},
            ),
            PopupMenuItem(
              child: const Text("Payments"),
              onTap: () {},
            ),
            settingsNavigatorMenu(context),
          ];
        }
        if (currentIndex == 1 || currentIndex == 2) {
          return [
            settingsNavigatorMenu(context),
          ];
        }
        return [
          PopupMenuItem(
            child: const Text("Clear call log"),
            onTap: () {},
          ),
          settingsNavigatorMenu(context),
        ];
      },
    ),
  ];
}
