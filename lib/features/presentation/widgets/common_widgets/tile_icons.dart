import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_small_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

 messageStatusWidget({required bool isGone, required bool isSeen}) {
  return Padding(
    padding:  EdgeInsets.only(bottom: (isSeen)?0: 2.h, top: isSeen?3.h:0),
    child: SvgPicture.asset(
      !isGone
          ? timer
          : isSeen
              ? doubleTick
              : singleTick,
      width: !isGone
          ? 12.w
          : isSeen
              ? 20.w
              : 15.w,
      height: !isGone
          ? 12.h
          : isSeen
              ? 20.h
              : 10.h,
      colorFilter: ColorFilter.mode(
        darkSmallTextColor,
        BlendMode.srcIn,
      ),
    ),
  );
}

Icon greyIconWidget({required iconName}) {
  return Icon(
    iconName,
    color: kGrey,
    size: 22.sp,
  );
}
Image tileMuteIconWidget() {
    return Image.asset(
      mute,
      width: 20.w,
      height: 17.h,
      color: darkSmallTextColor,
    );
  }
ChatTileSmallTextWidget recordingWidget({required bool isGroup}) {
  return  ChatTileSmallTextWidget(
    smallText: isGroup? "someOne Recording....": "Recording",
  );
}

ChatTileSmallTextWidget typingWidget({required bool isGroup}) {
  return ChatTileSmallTextWidget(
    smallText: isGroup? "someOne Typing....":"Typing",
  );
}

SvgPicture tileMicrophoneSvgIcon() {
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

SvgPicture tileDocumentSvgIcon() {
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
