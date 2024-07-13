import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_small_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

messageStatusWidget({
  required MessageStatus messageStatus,
  required bool isReceiverOnline,
  required bool isSenderOnline,
}) {
  return Padding(
    padding: EdgeInsets.only(
        bottom: messageStatus == MessageStatus.sent ? 0 : 2.h,
        top: messageStatus == MessageStatus.sent ? 3.h : 0),
    child: Icon(
      messageStatus == MessageStatus.sent
          ? messageStatus == MessageStatus.delivered
              ? messageStatus == MessageStatus.read
                  ? Icons.done_all
                  : Icons.done_all
              : Icons.done
          : Icons.update,
      color:  messageStatus == MessageStatus.sent
          ? messageStatus == MessageStatus.delivered
              ? messageStatus == MessageStatus.read
                  ? buttonSmallTextColor
                  : iconGreyColor
              : iconGreyColor
          : iconGreyColor,
      size: 18.sp,
    ),
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
