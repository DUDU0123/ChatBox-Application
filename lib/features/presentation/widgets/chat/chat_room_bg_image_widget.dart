import 'dart:developer';

import 'package:chatbox/config/theme/theme_manager.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget chatRoomBackgroundImageWidget({
  required BuildContext context,
  required ChatModel? chatModel,
  required GroupModel? groupModel,
}) {
  return SizedBox(
    width: screenWidth(context: context),
    height: screenHeight(context: context),
    child: wallPaperImage(chatModel: chatModel, groupModel: groupModel) != null
        ? Image.network(
            wallPaperImage(chatModel: chatModel, groupModel: groupModel)!,
            fit: BoxFit.cover,
          )
        : Image.asset(
            fit: BoxFit.cover,
            Provider.of<ThemeManager>(context).isDark ? bgImage : bgImage,
          ),
  );
}

String? wallPaperImage({
  required ChatModel? chatModel,
  required GroupModel? groupModel,
}) {
  if (chatModel != null) {
    return chatModel.chatWallpaper;
  } else {
    log(groupModel!.groupWallpaper??'');
    return groupModel?.groupWallpaper;
  }
}
