import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/presentation/widgets/common_widgets/tile_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Container(
//     height: 50.h,width: 50.h,
//     decoration: BoxDecoration(
//       color:  Provider.of<ThemeManager>(context).isDark?kBlack:kWhite,
//       borderRadius: BorderRadius.circular(100.sp),
//       boxShadow:  [
//         BoxShadow(
//           blurRadius: 3,
//           spreadRadius: 0,
//           offset: Offset(0, 1),
//           color: Provider.of<ThemeManager>(context).isDark?buttonSmallTextColor.withOpacity(0.3): Color.fromARGB(255, 9, 12, 35),
//         ),
//         BoxShadow(
//           blurRadius: 3,
//           spreadRadius: 0,
//           offset: Offset(-1, -1),
//           color:  Provider.of<ThemeManager>(context).isDark? buttonSmallTextColor.withOpacity(0.3):Color.fromARGB(255, 238, 236, 236),
//         ),
//       ],
//     ),
//     child:  Center(child: Icon(Icons.person, size: 50.sp,)),
//   );
Widget buildProfileImage({required String? userProfileImage}) {
  return CircleAvatar(
    backgroundColor: kGrey,
    radius: 25.sp,
    child: userProfileImage != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(25.sp),
            child: Image.network(
              userProfileImage,
              fit: BoxFit.cover,
            ),
          )
        : const Icon(
            Icons.person,
            color: Color.fromARGB(255, 134, 134, 134),
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

Widget buildSubtitle({
  required bool? isOutgoing,
  required bool? isIncomingMessage,
  required bool isGroup,
  required bool? isTyping,
  required bool? isVoiceRecoding,
  required bool? isGone,
  required bool? isSeen,
  required String? lastMessage,
  required bool? isAudio,
  required bool? isDocument,
  required bool? isPhoto,
  required bool? isRecordedAudio,
  required bool? isContact,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      if (isOutgoing ?? false)
        buildOutgoingStatus(
          isTyping: isTyping,
          isVoiceRecoding: isVoiceRecoding,
          isGone: isGone,
          isSeen: isSeen,
        ),
      if (isIncomingMessage ?? false)
        buildIncomingPrefix(
          isTyping: isTyping,
          isVoiceRecoding: isVoiceRecoding,
        ),
      buildMessageIcon(
        isAudio: isAudio,
        isContact: isContact,
        isDocument: isDocument,
        isPhoto: isPhoto,
        isRecordedAudio: isRecordedAudio,
        isGroup: isGroup,
        isTyping: isTyping,
        isVoiceRecoding: isVoiceRecoding,
      ),
      buildMessageText(
          isTyping: isTyping,
          isVoiceRecoding: isVoiceRecoding,
          lastMessage: lastMessage),
    ],
  );
}

Widget buildOutgoingStatus({
  required bool? isTyping,
  required bool? isVoiceRecoding,
  required bool? isGone,
  required bool? isSeen,
}) {
  if (!(isTyping ?? false) && !(isVoiceRecoding ?? false)) {
    return messageStatusWidget(
        isGone: isGone ?? false, isSeen: isSeen ?? false);
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

Widget buildMessageIcon({
  required bool isGroup,
  required bool? isTyping,
  required bool? isVoiceRecoding,
  required bool? isAudio,
  required bool? isDocument,
  required bool? isPhoto,
  required bool? isRecordedAudio,
  required bool? isContact,
}) {
  if (isTyping ?? false) return typingWidget(isGroup: isGroup);
  if (isVoiceRecoding ?? false) return recordingWidget(isGroup: isGroup);
  if (isAudio ?? false) return greyIconWidget(iconName: Icons.headphones);
  if (isPhoto ?? false) return greyIconWidget(iconName: Icons.photo);
  if (isDocument ?? false) return tileDocumentSvgIcon();
  if (isRecordedAudio ?? false) return tileMicrophoneSvgIcon();
  if (isContact ?? false) return greyIconWidget(iconName: Icons.person);
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
    width: screenWidth(context: context) / 6.6,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextWidgetCommon(
          text: lastMessageTime ?? '',
          fontSize: 10.sp,
          fontWeight: FontWeight.normal,
        ),
        Row(
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
