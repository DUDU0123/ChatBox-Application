import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/widgets/chat/icon_container_widget_gradient_color.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget userProfileImageShowWidget({
  required BuildContext context,
  required String imageUrl,
  double? radius,
}) {
  return CircleAvatar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    radius: radius?.sp ?? 20.sp,
    backgroundImage: NetworkImage(
      imageUrl,
    ),
  );
}

Widget chatDescriptionOrAbout({
  required bool isGroup,
  String? receiverAbout,
  String? groupDescription,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          // logic for add group description
        },
        child: TextWidgetCommon(
          text: !isGroup ? "About" : "Add Group Description",
          textColor: buttonSmallTextColor,
          overflow: TextOverflow.ellipsis,
          fontSize: 18.sp,
        ),
      ),
      TextWidgetCommon(
        text: !isGroup
            ? receiverAbout ?? ''
            : groupDescription ?? 'No description',
        overflow: TextOverflow.ellipsis,
        fontSize: 14.sp,
        textColor: iconGreyColor,
      ),
    ],
  );
}

Widget infoPageActionIconsBlueGradient({required bool isGroup}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      iconContainerWidgetGradientColor(
        size: 70,
        subtitle: "Audio",
        icon: Icons.call,
        onTap: () {},
      ),
      kWidth10,
      iconContainerWidgetGradientColor(
        size: 70,
        subtitle: "Video",
        icon: Icons.videocam_outlined,
        onTap: () {},
      ),
      kWidth10,
      isGroup
          ? iconContainerWidgetGradientColor(
              size: 70,
              subtitle: "Audio",
              icon: Icons.call,
              onTap: () {},
            )
          : zeroMeasureWidget,
      isGroup ? kWidth10 : zeroMeasureWidget,
      isGroup
          ? iconContainerWidgetGradientColor(
              size: 70,
              subtitle: "Video",
              icon: Icons.videocam_outlined,
              onTap: () {},
            )
          : zeroMeasureWidget,
    ],
  );
}