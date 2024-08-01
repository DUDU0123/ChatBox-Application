import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/config/common_provider/common_provider.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/widgets/chat/icon_container_widget_gradient_color.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/group_description_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Widget userProfileImageShowWidget(
    {required BuildContext context,
    required String imageUrl,
    double? radius,
    void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      radius: radius?.sp ?? 20.sp,
      backgroundImage: NetworkImage(
        imageUrl,
      ),
    ),
  );
}

Widget chatDescriptionOrAbout({
  required bool isGroup,
  String? receiverAbout,
  String? groupDescription,
  required BuildContext context,
  required GroupModel? groupData,
}) {
  return StreamBuilder<GroupModel?>(
      stream: groupData != null
          ? CommonDBFunctions.getOneGroupDataByStream(
              userID: firebaseAuth.currentUser!.uid,
              groupID: groupData.groupID!)
          : null,
      builder: (context, snapshot) {
        final commonProvider =
            Provider.of<CommonProvider>(context, listen: true);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                isGroup
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDescriptionAddPage(
                            groupModel: snapshot.data!,
                          ),
                        ))
                    : null;
              },
              child: TextWidgetCommon(
                text: !isGroup ? "About" : "Add Group Description",
                textColor: buttonSmallTextColor,
                overflow: TextOverflow.ellipsis,
                fontSize: 18.sp,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextWidgetCommon(
                  text: !isGroup
                      ? receiverAbout ?? ''
                      : snapshot.data?.groupDescription ?? 'No description',
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14.sp,
                  textColor: iconGreyColor,
                  maxLines: !isGroup
                      ? 1
                      : !commonProvider.isExpanded
                          ? 6
                          : null,
                ),
                if (isGroup)
                  isGroup
                      ? snapshot.data != null
                          ? snapshot.data?.groupDescription != null
                              ? snapshot.data!.groupDescription!.length > 100
                                  ? readMoreButton(
                                      context: context,
                                      commonProvider: commonProvider)
                                  : zeroMeasureWidget
                              : zeroMeasureWidget
                          : zeroMeasureWidget
                      : zeroMeasureWidget,
              ],
            ),
            (groupData != null && isGroup)
                ? StreamBuilder<UserModel?>(
                    stream: groupData.createdBy != null
                        ? groupData.createdBy!.isNotEmpty
                            ? CommonDBFunctions
                                .getOneUserDataFromDataBaseAsStream(
                                    userId: groupData.createdBy!)
                            : null
                        : null,
                    builder: (context, snapshot) {
                      return TextWidgetCommon(
                        text:
                            "Created by ${snapshot.data?.contactName ?? snapshot.data?.userName ?? ''}, (${DateProvider.formatMessageDateTime(
                          messageDateTimeString: groupData.groupCreatedAt.toString(),isInsideChat: true,
                        )})",
                        fontSize: 14.sp,
                        textColor: iconGreyColor,
                        fontWeight: FontWeight.normal,
                      );
                    })
                : zeroMeasureWidget,
          ],
        );
      });
}

Widget infoPageActionIconsBlueGradient({required bool isGroup, required BuildContext context,}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      iconContainerWidgetGradientColor(
        size: 75.sp,
        subtitle: "Audio",
        icon: Icons.call,
        onTap: () {},
      ),
      kWidth10,
      iconContainerWidgetGradientColor(
        size: 75.sp,
        subtitle: !isGroup ? "Video" : "Chat",
        icon: !isGroup ? Icons.videocam_outlined : Icons.chat_outlined,
        onTap: () {
          if (isGroup) {
            Navigator.pop(context);
          }
        },
      ),
      kWidth10,
    ],
  );
}
