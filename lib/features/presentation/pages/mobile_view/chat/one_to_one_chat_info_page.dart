import 'dart:developer';

import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat/icon_container_widget_gradient_color.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OneToOneChatInfoPage extends StatelessWidget {
  const OneToOneChatInfoPage({
    super.key,
    required this.receiverData,
    this.receiverContactName,
  });
  final UserModel? receiverData;
  final String? receiverContactName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            kWidth5,
            receiverData?.userProfileImage != null
                ? CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    radius: 20.sp,
                    backgroundImage:
                        NetworkImage(receiverData!.userProfileImage!),
                  )
                : nullImageReplaceWidget(containerRadius: 20, context: context),
            kWidth5,
            Expanded(
              child: TextWidgetCommon(
                text: receiverContactName ?? receiverData?.userName ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            )
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [];
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    receiverData?.userProfileImage != null
                        ? CircleAvatar(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            radius: 80.sp,
                            backgroundImage:
                                NetworkImage(receiverData!.userProfileImage!),
                          )
                        : nullImageReplaceWidget(
                            containerRadius: 80, context: context),
                    kHeight10,
                    TextWidgetCommon(
                      textAlign: TextAlign.center,
                      text: receiverContactName ?? receiverData?.userName ?? '',
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20.sp,
                    ),
                    kHeight5,
                    TextWidgetCommon(
                      text: receiverData?.phoneNumber ?? '',
                      textAlign: TextAlign.center,
                      textColor: iconGreyColor,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20.sp,
                    ),
                  ],
                ),
              ),
              kHeight20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconContainerWidgetGradientColor(
                    size: 80,
                    subtitle: "Audio",
                    icon: Icons.call,
                    onTap: () {},
                  ),
                  kWidth10,
                  iconContainerWidgetGradientColor(
                    size: 80,
                    subtitle: "Video",
                    icon: Icons.videocam_outlined,
                    onTap: () {},
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidgetCommon(
                    text: "About",
                    textColor: buttonSmallTextColor,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 18.sp,
                  ),
                  TextWidgetCommon(
                    text: receiverData?.userAbout ?? '',
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14.sp,
                    textColor: iconGreyColor,
                  ),
                ],
              ),
              kHeight25,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidgetCommon(
                    text:
                        "Groups in common (${receiverData!.userGroupIdList?.length})",
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14.sp,
                    textColor: iconGreyColor,
                  ),
                  kHeight15,
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return FutureBuilder<GroupModel?>(
                          future: CommonDBFunctions.getGroupDetailsByGroupID(
                            groupID: receiverData?.userGroupIdList![index],
                            userID: receiverData!.id!,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              log("Some Error Occured ${snapshot.error} ${snapshot.stackTrace}");
                              return commonErrorWidget(
                                  message: "Some Error Occured ${snapshot.error} ${snapshot.stackTrace}");
                            }
                            if (snapshot.data == null || !snapshot.hasData) {
                              return commonErrorWidget(
                                  message: "No group Data Available");
                            }
                            return commonGroupDataShowWidgetInChatInfo(
                              context: context,
                              groupData: snapshot.data,
                            );
                          });
                    },
                    separatorBuilder: (context, index) => kHeight5,
                    itemCount: receiverData!.userGroupIdList!.length,
                  ),
                ],
              ),
              commonListTile(
                onTap: () {},
                title: "Block ${receiverData?.userName ?? ''}",
                isSmallTitle: false,
                context: context,
                color: kRed,
                leading: Icon(
                  Icons.block,
                  color: kRed,
                  size: 28.sp,
                ),
              ),
              commonListTile(
                onTap: () {},
                title: "Report ${receiverData?.userName ?? ''}",
                isSmallTitle: false,
                context: context,
                color: kRed,
                leading: Icon(
                  Icons.report_outlined,
                  color: kRed,
                  size: 28.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonGroupDataShowWidgetInChatInfo(
      {required BuildContext context, required GroupModel? groupData}) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              groupModel: groupData,
              userName: groupData.groupName ?? '',
              isGroup: true,
            ),
          ),
        );
      },
      leading: GestureDetector(
        child: buildProfileImage(
          userProfileImage: null,
          context: context,
        ),
      ),
      title: buildUserName(userName: groupData!.groupName ?? ''),
      subtitle: TextWidgetCommon(
        text: "text",
        fontSize: 12.sp,
        textColor: iconGreyColor,
      ),
    );
  }
}
