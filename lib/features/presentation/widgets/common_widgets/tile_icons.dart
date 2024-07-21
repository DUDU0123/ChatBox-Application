import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_small_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
Widget messageStatusWidget({
  required MessageStatus messageStatus,
}) {
  IconData icon;
  Color iconColor;

  switch (messageStatus) {
    case MessageStatus.sent:
      icon = Icons.done;
      iconColor = iconGreyColor;
      break;
    case MessageStatus.delivered:
      icon = Icons.done_all;
      iconColor = iconGreyColor;
      break;
    case MessageStatus.read:
      icon = Icons.done_all;
      iconColor = buttonSmallTextColor;
      break;
    default:
      icon = Icons.update;
      iconColor = iconGreyColor;
      break;
  }

  return Icon(
    icon,
    color: iconColor,
    size: 18.sp,
  );
}


Widget greyIconWidget({required iconName}) {
  return Icon(
    iconName,
    color: kGrey,
    size: 22.sp,
  );
}

Widget tileMuteIconWidget() {
  return Image.asset(
    mute,
    width: 20.w,
    height: 17.h,
    color: darkSmallTextColor,
  );
}

ChatTileSmallTextWidget recordingWidget({required bool isGroup}) {
  return ChatTileSmallTextWidget(
    smallText: isGroup ? "someOne Recording...." : "Recording",
  );
}

ChatTileSmallTextWidget typingWidget({required bool isGroup}) {
  return ChatTileSmallTextWidget(
    smallText: isGroup ? "someOne Typing...." : "Typing",
  );
}

Widget tileMicrophoneSvgIcon() {
  //{required bool isReaded}
  return SvgPicture.asset(
    microphoneFilled,
    width: 25.w,
    height: 18.h,
    colorFilter: ColorFilter.mode(
      //isReaded?
      kGrey,
      //: buttonSmallTextColor,
      BlendMode.srcIn,
    ),
  );
}

Widget tileDocumentSvgIcon() {
  return SvgPicture.asset(
    document,
    width: 25.w,
    height: 20.h,
    colorFilter: ColorFilter.mode(
      kGrey,
      BlendMode.srcIn,
    ),
  );
}
