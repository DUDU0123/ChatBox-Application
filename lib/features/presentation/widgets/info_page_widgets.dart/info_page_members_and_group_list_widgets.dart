import 'dart:developer';
import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/chat_tile_widgets.dart';
import 'package:chatbox/features/presentation/widgets/chat_home/user_profile_show_dialog.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/dialog_widgets/normal_dialogbox_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget infoPageGroupMembersList({
  required GroupModel? groupData,
  required BuildContext context,
}) {
  return Column(
    children: [
      addGroupMembersTile(
        context: context,
        groupModel: groupData,
      ),
      groupData!.adminsPermissions!
                  .contains(AdminsGroupPermission.viewMembers) &&
              !groupData.groupAdmins!.contains(firebaseAuth.currentUser?.uid)
          ? zeroMeasureWidget
          : ListView.separated(
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
                        return commonErrorWidget(
                            message: "No group Data Available");
                      }
                      return groupMemberListTileWidget(
                        context: context,
                        snapshot: snapshot,
                        groupData: groupData,
                      );
                    });
              },
              separatorBuilder: (context, index) => kHeight5,
              itemCount: groupData.groupMembers!.length,
            ),
    ],
  );
}

Widget addGroupMembersTile({
  required BuildContext context,
  required GroupModel? groupModel,
}) {
  if (groupModel == null) {
    return zeroMeasureWidget;
  }
  return !groupModel.membersPermissions!
              .contains(MembersGroupPermission.addMembers) &&
          groupModel.groupAdmins!.contains(firebaseAuth.currentUser?.uid)
      ? addTile(context: context, groupmodel: groupModel)
      : groupModel.membersPermissions!
              .contains(MembersGroupPermission.addMembers)
          ? addTile(context: context, groupmodel: groupModel)
          : zeroMeasureWidget;
}

Widget addTile({
  required BuildContext context,
  String? tileText = "Add members",
  required GroupModel groupmodel
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
          onPressed: () {
            if (tileText == "Add members") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectContactPage(
                    pageType: PageTypeEnum.groupInfoPage,
                    isGroup: true,
                    groupModel: groupmodel,
                  ),
                ),
              );
            }
          },
          icon: Icon(
            Icons.add,
            color: kBlack,
            size: 28.sp,
          ),
        ),
      ),
    ),
    title: TextWidgetCommon(
      text: tileText ?? "Add members",
      textColor: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}

Widget groupMemberListTileWidget({
  required BuildContext context,
  required AsyncSnapshot<UserModel?> snapshot,
  required GroupModel groupData,
}) {
  final String? groupMemberName =
      snapshot.data?.contactName ?? snapshot.data?.userName;
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
    title: TextWidgetCommon(text: groupMemberName ?? ''),
    trailing: groupData.groupAdmins!.contains(snapshot.data?.id)
        ? commonContainerChip(
            chipText: "Group Admin",
            chipColor: buttonSmallTextColor.withOpacity(0.3),
            chipWidth: 100.w,
          )
        : groupData.groupAdmins!.contains(firebaseAuth.currentUser?.uid)
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        normalDialogBoxWidget(
                          context: context,
                          title: "Remove $groupMemberName",
                          subtitle:
                              "$groupMemberName will permanently removed from this group",
                          onPressed: () {},
                          actionButtonName: "Remove",
                        );
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        color: kRed.withOpacity(0.6),
                      )),
                  commonContainerChip(
                    chipWidth: 80.w,
                    chipColor: buttonSmallTextColor.withOpacity(0.3),
                    chipText: "as admin",
                    onTap: () {
                      normalDialogBoxWidget(
                          context: context,
                          title: "Make $groupMemberName as admin",
                          subtitle:
                              "$groupMemberName will be able to manage this group data",
                          onPressed: () {},
                          actionButtonName: "Make as admin");
                    },
                  ),
                ],
              )
            : zeroMeasureWidget,
  );
}

Widget commonContainerChip(
    {void Function()? onTap,
    required String chipText,
    required Color chipColor,
    required double chipWidth}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.sp),
        color: chipColor,
      ),
      height: 20.h,
      width: chipWidth,
      //  chipText == "Remove" ? 80.w : 100.w,
      child: Center(
        child: TextWidgetCommon(
          text: chipText,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
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
