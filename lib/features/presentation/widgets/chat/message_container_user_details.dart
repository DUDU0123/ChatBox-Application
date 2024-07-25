import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

StreamBuilder<UserModel?> messageContainerUserDetails(
    {required MessageModel message}) {
  return StreamBuilder<UserModel?>(
      stream: CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
          userId: message.senderID ?? ''),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return zeroMeasureWidget;
        }
        final contactName = snapshot.data?.contactName;
        String prefix = '';
        if (contactName == null || contactName.isEmpty) {
          prefix = '~';
        }
        String? messageSenderProfileImage = snapshot.data!.userProfileImage;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            messageSenderProfileImage != null
                ? userProfileImageShowWidget(
                    context: context,
                    imageUrl: messageSenderProfileImage,
                    radius: 10,
                  )
                : nullImageReplaceWidget(
                    containerRadius: 20,
                    context: context,
                  ),
            kWidth5,
            Expanded(
              child: TextWidgetCommon(
                text:
                    "$prefix${snapshot.data?.contactName ?? snapshot.data!.userName ?? ''}",
                overflow: TextOverflow.ellipsis,
                fontSize: 10.sp,
                textColor: kWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
            kWidth2,
            TextWidgetCommon(
              text: snapshot.data?.phoneNumber ?? "",
              fontSize: 10.sp,
              textColor: kBlack,
              fontWeight: FontWeight.w600,
            )
          ],
        );
      });
}
