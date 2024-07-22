import 'dart:developer';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/user_profile_show_dialog.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget infoPageGroupMembersList({
  required GroupModel? groupData,
  required BuildContext context,
}) {
  return Column(
    children: [
      addGroupMembersTile(context: context),
      ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return FutureBuilder<UserModel?>(
              future: CommonDBFunctions.getOneUserDataFromDBFuture(
                  userId: groupData.groupMembers![index]),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  log("Some Error Occured ${snapshot.error} ${snapshot.stackTrace}");
                  return commonErrorWidget(
                      message:
                          "Some Error Occured ${snapshot.error} ${snapshot.stackTrace}");
                }
                if (snapshot.data == null || !snapshot.hasData) {
                  return commonErrorWidget(message: "No group Data Available");
                }
                return groupMemberListTileWidget(
                  context: context,
                  snapshot: snapshot,
                  groupData: groupData,
                );
              });
        },
        separatorBuilder: (context, index) => kHeight5,
        itemCount: groupData!.groupMembers!.length,
      ),
    ],
  );
}

Widget addGroupMembersTile({
  required BuildContext context,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.all(0),
    leading: Container(
      height: 50.h,
      width: 50.w,
      decoration: BoxDecoration(
        border: Border.all(color: kWhite, width: 2.w),
        shape: BoxShape.circle,
        color: darkSwitchColor,
      ),
      child: Center(
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add,
            color: kBlack,
            size: 28.sp,
          ),
        ),
      ),
    ),
    title: TextWidgetCommon(
      text: "Add members",
      textColor: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}

Widget groupMemberListTileWidget({
  required BuildContext context,
  required AsyncSnapshot<UserModel?> snapshot,
  required GroupModel groupData,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.all(0),
    leading: GestureDetector(
      onTap: () {
        log("Tapped image");
        userProfileShowDialog(
          context: context,
          userProfileImage: snapshot.data?.userProfileImage,
        );
      },
      child: buildProfileImage(
        userProfileImage: snapshot.data?.userProfileImage,
        context: context,
      ),
    ),
    title: TextWidgetCommon(
        text: snapshot.data?.contactName ?? snapshot.data?.userName ?? ''),
    trailing: groupData.groupAdmins!.contains(snapshot.data?.id)
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.sp),
              color: buttonSmallTextColor.withOpacity(0.3),
            ),
            height: 20.h,
            width: 100.w,
            child: Center(
              child: TextWidgetCommon(
                text: "Group Admin",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        : zeroMeasureWidget,
  );
}

Widget infoPageCommonGroupList({
  required UserModel? receiverData,
}) {
  return ListView.separated(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (context, index) {
      return FutureBuilder<GroupModel?>(
          future: CommonDBFunctions.getGroupDetailsByGroupID(
            groupID: receiverData.userGroupIdList![index],
            userID: receiverData.id!,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              log("Some Error Occured ${snapshot.error} ${snapshot.stackTrace}");
              return commonErrorWidget(
                  message:
                      "Some Error Occured ${snapshot.error} ${snapshot.stackTrace}");
            }
            if (snapshot.data == null || !snapshot.hasData) {
              return commonErrorWidget(message: "No group Data Available");
            }
            return commonGroupDataShowWidgetInChatInfo(
              context: context,
              groupData: snapshot.data,
            );
          });
    },
    separatorBuilder: (context, index) => kHeight5,
    itemCount: receiverData!.userGroupIdList!.length,
  );
}

Widget commonGroupDataShowWidgetInChatInfo({
  required BuildContext context,
  required GroupModel? groupData,
}) {
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
  );
}
