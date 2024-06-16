import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatListTileWidget extends StatelessWidget {
  const ChatListTileWidget({
    super.key,
    required this.userName,
    required this.lastMessage,
    required this.isSeen,
    required this.userProfileImage,
    required this.lastMessageArrivedTime,
    required this.notificationNUmber,
    required this.isNotificationCome,
    required this.isGone,
    required this.isMutedChat,
  });
  final bool isGone;
  final String userName;
  final String lastMessage;
  final bool isSeen;
  final String userProfileImage;
  final String lastMessageArrivedTime;
  final int notificationNUmber;
  final bool isNotificationCome;
  // message section
  final bool isMutedChat;
  // final bool isTyping;
  // final bool isVoiceRecoding;
  // final bool isPhoto;
  // final bool isIncomingMessage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: CircleAvatar(
        radius: 25.sp,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.sp),
          child: Image.asset(
            userProfileImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: TextWidgetCommon(
        text: userName,
        overflow: TextOverflow.ellipsis,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
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
          kWidth5,
          Expanded(
            child: TextWidgetCommon(
              text: lastMessage,
              overflow: TextOverflow.ellipsis,
              textColor: kGrey,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
      trailing: SizedBox(
        width: screenWidth(context: context) / 6.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextWidgetCommon(
              text: lastMessageArrivedTime,
              fontSize: 10.sp,
              fontWeight: FontWeight.normal,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isMutedChat
                    ? Image.asset(
                        mute,
                        width: 20.w,
                        height: 17.h,
                        color: darkSmallTextColor,
                      )
                    : zeroMeasureWidget,
                kWidth5,
                isNotificationCome
                    ? Container(
                        height: 20.h,
                        width: 28.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.sp),
                          color: buttonSmallTextColor,
                        ),
                        child: Center(
                          child: TextWidgetCommon(
                            text: notificationNUmber.toString(),
                            fontSize: 12.sp,
                            textColor: kWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : zeroMeasureWidget,
              ],
            )
          ],
        ),
      ),
    );
  }
}
