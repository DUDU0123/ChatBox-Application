import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbox/config/common_provider/common_provider.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/chat_asset_send_methods.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/camera_photo_pick/asset_show_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

Widget locationMessageWidget({required MessageModel message}) {
  return Column(
    children: [
      SvgPicture.asset(
        location,
        width: 50.w,
        height: 50.w,
        colorFilter: ColorFilter.mode(
          kBlack,
          BlendMode.srcIn,
        ),
      ),
      TextButton(
        onPressed: () async {
          await canLaunchUrlString(message.message ?? '')
              ? await launchUrlString(message.message ?? '')
              : null;
        },
        child: TextWidgetCommon(
          text: "Open Location",
          textColor: kWhite,
          fontSize: 18.sp,
        ),
      ),
    ],
  );
}

Widget textMessageWidget({
  required MessageModel message,
  required BuildContext context,
}) {
  final commonProvider = Provider.of<CommonProvider>(context, listen: true);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      TextWidgetCommon(
        fontSize: 16.sp,
        maxLines: !commonProvider.isExpandedMessage(message.messageId!) ? 30 : null,
        text: message.message ?? '',
        textColor: kWhite,
      ),
     message.message!=null && message.message!.length > 1000
          ? readMoreButton(
              context: context,
              commonProvider: commonProvider,
              fontSize: 16,
              isInMessageList: true,
              messageID: message.messageId)
          : zeroMeasureWidget,
    ],
  );
}

Widget documentMessageWidget({
  required MessageModel message,
}) {
  return GestureDetector(
    onTap: () {
      openDocument(url: message.message ?? '');
    },
    child: Row(
      children: [
        SvgPicture.asset(
          document,
          width: 30.w,
          height: 30.h,
          colorFilter: ColorFilter.mode(
            kWhite,
            BlendMode.srcIn,
          ),
        ),
        Expanded(
          child: TextWidgetCommon(
            overflow: TextOverflow.ellipsis,
            text: message.name ?? '',
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
        )
      ],
    ),
  );
}

Widget photoMessageShowWidget({
  required MessageModel message,
  required ChatModel? chatModel,
  required BuildContext context,
  required String receiverID,
  required bool isGroup,
  GroupModel? groupModel,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.sp),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssetShowPage(
              isGroup: isGroup,
              groupModel: groupModel,
              receiverID: receiverID,
              messageType: MessageType.photo,
              chatID: chatModel?.chatID ?? '',
              message: message,
            ),
          ),
        );
      },
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        placeholder: (context, url) => commonAnimationWidget(
          context: context,
          isTextNeeded: false,
        ),
        imageUrl: message.message ?? '',
      ),
    ),
  );
}

Widget videoMessageShowWidget({
  required MessageModel message,
  required ChatModel? chatModel,
  required BuildContext context,
  required String receiverID,
  required final Map<String, VideoPlayerController> videoControllers,
  required bool isGroup,
  GroupModel? groupModel,
}) {
  return GestureDetector(
    onTap: () {
      log(
        videoControllers[message.message!]!.value.duration.toString(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssetShowPage(
            isGroup: isGroup,
            groupModel: groupModel,
            receiverID: receiverID,
            messageType: MessageType.video,
            chatID: chatModel?.chatID ?? '',
            controllers: videoControllers,
            message: message,
          ),
        ),
      );
    },
    child: Stack(
      children: [
        VideoPlayer(
          videoControllers[message.message!]!,
        ),
        Positioned(
          bottom: 3,
          left: 5,
          child: TextWidgetCommon(
            text: DateProvider.parseDuration(
              videoControllers[message.message!]!.value.duration.toString(),
            ),
            textColor: kWhite,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 30.sp,
            backgroundColor: iconGreyColor.withOpacity(0.5),
            child: Icon(
              !videoControllers[message.message!]!.value.isPlaying
                  ? Icons.play_arrow
                  : Icons.pause,
              size: 30.sp,
              color: kBlack,
            ),
          ),
        ),
      ],
    ),
  );
}
