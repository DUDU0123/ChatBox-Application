import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';

class UserTileWithNameAndAboutAndProfileImage extends StatelessWidget {
  const UserTileWithNameAndAboutAndProfileImage({
    super.key,
    required this.userName,
    this.userAbout,
    this.userPicture, this.trailing, this.onTap,
  });
  final String userName;
  final String? userAbout;
  final String? userPicture;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: trailing,
      onTap: onTap,
      leading: buildProfileImage(userProfileImage: userPicture, context: context,),
      title: buildUserName(userName: userName),
      subtitle: userAbout != null
          ? TextWidgetCommon(
              text: userAbout!,
              textColor: iconGreyColor,
            )
          : zeroMeasureWidget,
    );
  }
}
