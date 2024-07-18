
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/tile_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
Widget buildProfileImage({
  required String? userProfileImage,
  required BuildContext context,
}) {
  return userProfileImage != null
      ? Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: Theme.of(context).popupMenuTheme.color,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(userProfileImage),
              fit: BoxFit.cover,
            ),
          ),
        )
      : Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: Theme.of(context).popupMenuTheme.color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.person,
              color: const Color.fromARGB(255, 134, 134, 134),
              size: 30.sp,
            ),
          ),
        );
}

Widget buildUserName({required String userName}) {
  return TextWidgetCommon(
    text: userName,
    overflow: TextOverflow.ellipsis,
    fontSize: 17.sp,
    fontWeight: FontWeight.bold,
  );
}

Widget buildSubtitle(
    {required bool? isIncomingMessage,
    required bool isGroup,
    required bool? isTyping,
    required bool? isVoiceRecoding,
    required String? lastMessage,
    required MessageStatus messageStatus}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      if (isIncomingMessage == null) zeroMeasureWidget,
      if (isIncomingMessage == false)
        buildOutgoingStatus(
          messageStatus: messageStatus,
          isTyping: isTyping,
          isVoiceRecoding: isVoiceRecoding,
        ),
      if (isGroup && isIncomingMessage == true)
        buildIncomingPrefix(
          isTyping: isTyping,
          isVoiceRecoding: isVoiceRecoding,
        ),
      buildMessageText(
        isTyping: isTyping,
        isVoiceRecoding: isVoiceRecoding,
        lastMessage: lastMessage,
      ),
    ],
  );
}

Widget buildOutgoingStatus(
    {required bool? isTyping,
    required bool? isVoiceRecoding,
    required MessageStatus messageStatus}) {
  if (!(isTyping ?? false) && !(isVoiceRecoding ?? false)) {
    return messageStatusWidget(
      messageStatus: messageStatus,
    );
  }
  return zeroMeasureWidget;
}

Widget buildIncomingPrefix({
  required bool? isTyping,
  required bool? isVoiceRecoding,
}) {
  if (!(isTyping ?? false) && !(isVoiceRecoding ?? false)) {
    return TextWidgetCommon(
      text: "~Irshad: ",
      textColor: kGrey,
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
    );
  }
  return zeroMeasureWidget;
}

Widget buildMessageText({
  required bool? isTyping,
  required bool? isVoiceRecoding,
  required String? lastMessage,
}) {
  return Expanded(
    child: TextWidgetCommon(
      text: (!(isTyping ?? false) && !(isVoiceRecoding ?? false))
          ? lastMessage ?? ''
          : '',
      overflow: TextOverflow.ellipsis,
      textColor: kGrey,
      fontSize: 14.sp,
    ),
  );
}

Widget buildTrailing(
    {required BuildContext context,
    required int? notificationCount,
    required bool? isMutedChat,
    required String? lastMessageTime}) {
  return SizedBox(
    // width: screenWidth(context: context) / 8,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextWidgetCommon(
          text: lastMessageTime ?? '',
          fontSize: 10.sp,
          fontWeight: FontWeight.normal,
          textColor: kGrey,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isMutedChat ?? false) tileMuteIconWidget(),
            kWidth5,
            if (notificationCount != null)
              if (notificationCount > 0)
                buildNotificationBadge(
                  notificationCount: notificationCount,
                ),
          ],
        ),
      ],
    ),
  );
}

Widget buildNotificationBadge({required int? notificationCount}) {
  return Container(
    height: 20.h,
    width: 28.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.sp),
      color: buttonSmallTextColor,
    ),
    child: Center(
      child: TextWidgetCommon(
        text: notificationCount.toString(),
        fontSize: 12.sp,
        textColor: kWhite,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
