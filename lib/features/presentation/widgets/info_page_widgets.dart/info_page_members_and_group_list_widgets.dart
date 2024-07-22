import 'dart:developer';

import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_listtile_widget.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget infoPageGroupMembersList({required GroupModel? groupData}) {
  return ListView.separated(
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
            return ChatListTileWidget(
              contentPadding: const EdgeInsets.all(0),
              userName: snapshot.data?.userName ?? '',
              isGroup: false,
              messageStatus: MessageStatus.none,
            );
          });
    },
    separatorBuilder: (context, index) => kHeight5,
    itemCount: groupData!.groupMembers!.length,
  );
}

Widget infoPageCommonGroupList({required UserModel? receiverData}) {
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
  );
}
