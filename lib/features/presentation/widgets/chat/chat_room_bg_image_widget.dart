import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget chatRoomBackgroundImageWidget(BuildContext context) {
  return SizedBox(
    width: screenWidth(context: context),
    height: screenHeight(context: context),
    child: Image.asset(
      fit: BoxFit.cover,
      Provider.of<ThemeManager>(context).isDark ? bgImage : bgImage,
    ),
  );
}
