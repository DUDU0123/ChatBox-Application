import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget infoPageUserDetailsPart({
  required BuildContext context,
  required UserModel? receiverData,
  required GroupModel? groupData,
  required bool isGroup,
  required String? receiverContactName,
}) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        receiverData?.userProfileImage != null && !isGroup
            ? userProfileImageShowWidget(
                context: context,
                imageUrl: receiverData!.userProfileImage!,
                radius: 80,
              )
            : groupData?.groupProfileImage != null
                ? userProfileImageShowWidget(
                    context: context,
                    imageUrl: groupData!.groupProfileImage!,
                    radius: 80,
                  )
                : nullImageReplaceWidget(
                    containerRadius: 150, context: context),
        kHeight10,
        TextWidgetCommon(
          textAlign: TextAlign.center,
          text: !isGroup
              ? receiverContactName ?? receiverData?.userName ?? ''
              : groupData?.groupName ?? '',
          overflow: TextOverflow.ellipsis,
          fontSize: 20.sp,
        ),
       isGroup?zeroMeasureWidget: kHeight5,
        TextWidgetCommon(
          text: !isGroup
              ? receiverData?.phoneNumber ?? ''
              : "${groupData?.groupMembers?.length} Members",
          textAlign: TextAlign.center,
          textColor: iconGreyColor,
          overflow: TextOverflow.ellipsis,
          fontSize:!isGroup? 20.sp:13.sp,
        ),
        kHeight10,
        TextWidgetCommon(
          textAlign: TextAlign.center,
          text: isGroup? 
          "Created at ${DateProvider.convertDateToFormatted(date: groupData!.groupCreatedAt.toString())}"
          // "Created at ${DateProvider.formatMessageDateTime(isInsideChat: true, messageDateTimeString: groupData!.groupCreatedAt.toString())}"
          :'',
          overflow: TextOverflow.ellipsis,
          fontSize: 14.sp,
          textColor: iconGreyColor,
        ),
      ],
    ),
  );
}
