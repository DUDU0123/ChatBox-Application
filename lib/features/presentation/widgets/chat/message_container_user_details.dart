import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
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
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
