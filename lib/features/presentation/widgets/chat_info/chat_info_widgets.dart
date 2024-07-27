import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/group/group_pages/group_permissions_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_gradient_tile_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/group_member_tile_small_widgets.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_members_and_group_list_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget heightWidgetReturnOnCondition({
  required bool isGroup,
  required GroupModel? groupData,
}) {
  return isGroup
      ? groupData!.adminsPermissions!
                  .contains(AdminsGroupPermission.viewMembers) &&
              !groupData.groupAdmins!.contains(firebaseAuth.currentUser?.uid)
          ? zeroMeasureWidget
          : kHeight20
      : kHeight20;
}

Widget groupPermissionGraientContainerWidget({
  required BuildContext context,
  required GroupModel? groupData,
}) {
  return CommonGradientTileWidget(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamBuilder<GroupModel?>(
              stream: groupData != null
                  ? CommonDBFunctions.getOneGroupDataByStream(
                      userID: firebaseAuth.currentUser!.uid,
                      groupID: groupData.groupID!)
                  : null,
              builder: (context, snapshot) {
                return GroupPermissionsPage(
                  pageType: PageTypeEnum.groupInfoPage,
                  groupModel: snapshot.data,
                );
              }),
        ),
      );
    },
    rootContext: context,
    isSmallTitle: false,
    title: "Group Permissions",
    trailing: Icon(
      Icons.settings,
      color: kWhite,
    ),
  );
}

Widget chatMediaGradientContainerWidget({
  required BuildContext context,
}) {
  return CommonGradientTileWidget(
    onTap: () {},
    rootContext: context,
    isSmallTitle: false,
    title: "Media,links and docs",
    trailing: Icon(
      Icons.arrow_forward_ios,
      color: kWhite,
    ),
  );
}

Widget membersListOrGroupListWidget({
  required BuildContext context,
  required UserModel? receiverData,
  required GroupModel? groupData,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StreamBuilder<GroupModel?>(
        stream:groupData!=null? CommonDBFunctions.getOneGroupDataByStream(userID: firebaseAuth.currentUser!.uid, groupID: groupData.groupID??''):null,
        builder: (context, snapshot) {
          return TextWidgetCommon(
            text: receiverData != null
                ? "Groups in common (${receiverData.userGroupIdList?.length})"
                : groupData!.adminsPermissions!
                            .contains(AdminsGroupPermission.viewMembers) &&
                        !groupData.groupAdmins!
                            .contains(firebaseAuth.currentUser?.uid)
                    ? ""
                    : "${snapshot.data?.groupMembers?.length??groupData.groupMembers?.length} Members",
            overflow: TextOverflow.ellipsis,
            fontSize: 14.sp,
            textColor: iconGreyColor,
          );
        }
      ),
      kHeight15,
      if (receiverData != null)
        infoPageCommonGroupList(
          receiverData: receiverData,
        ),
      if (groupData != null)
        infoPageGroupMembersList(
          context: context,
          groupData: groupData,
        )
    ],
  );
}