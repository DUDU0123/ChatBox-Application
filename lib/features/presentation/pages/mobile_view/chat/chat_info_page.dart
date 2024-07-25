import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/features/data/data_sources/group_data/group_data.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/group/group_pages/group_permissions_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_gradient_tile_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_list_tile.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_appbar_content_widget.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_list_tile_widget.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_members_and_group_list_widgets.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_user_details_part_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInfoPage extends StatelessWidget {
  const ChatInfoPage({
    super.key,
    this.receiverData,
    this.receiverContactName,
    this.groupData,
    required this.isGroup,
  });
  final UserModel? receiverData;
  final String? receiverContactName;
  final GroupModel? groupData;
  final bool isGroup;
  @override
  Widget build(BuildContext context) {
    List<String>? groupAdmins = groupData?.groupAdmins;
    bool isAdmin =
        groupAdmins?.contains(firebaseAuth.currentUser?.uid) ?? false;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: infoPageAppBarContentWidget(
          context: context,
          receiverData: receiverData,
          groupData: groupData,
          isGroup: isGroup,
          receiverContactName: receiverContactName,
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
              infoPageUserDetailsPart(
                context: context,
                receiverData: receiverData,
                groupData: groupData,
                isGroup: isGroup,
                receiverContactName: receiverContactName,
              ),
              kHeight20,
              infoPageActionIconsBlueGradient(
                isGroup: isGroup,
              ),
              chatDescriptionOrAbout(
                isGroup: isGroup,
                receiverAbout: receiverData?.userAbout,
                groupDescription: groupData?.groupDescription,
              ),
              kHeight20,
              !isGroup
                  ? chatMediaGradientContainerWidget(context: context)
                  : isAdmin
                      ? groupPermissionGraientContainerWidget(
                          context: context, groupData: groupData)
                      : zeroMeasureWidget,
              kHeight20,
              membersListOrGroupListWidget(
                context: context,
                receiverData: receiverData,
                groupData: groupData,
              ),
              kHeight20,
              isGroup && groupAdmins != null
                  ? groupAdmins.contains(firebaseAuth.currentUser?.uid)
                      ? commonListTile(
                          leading: Icon(
                            Icons.delete_outline,
                            color: kRed,
                            size: 28.sp,
                          ),
                          color: kRed,
                          onTap: () {},
                          title: "Delete Group",
                          isSmallTitle: false,
                          context: context,
                        )
                      : zeroMeasureWidget
                  : zeroMeasureWidget,
              infoPageListTileWidget(
                context: context,
                isGroup: isGroup,
                receiverData: receiverData,
                isFirstTile: true,
              ),
              infoPageListTileWidget(
                context: context,
                isGroup: isGroup,
                receiverData: receiverData,
                isFirstTile: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
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
          builder: (context) => GroupPermissionsPage(
            pageType: PageTypeEnum.groupInfoPage,
            groupModel: groupData,
          ),
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
      TextWidgetCommon(
        text: receiverData != null
            ? "Groups in common (${receiverData.userGroupIdList?.length})"
            : "${groupData?.groupMembers?.length} Members",
        overflow: TextOverflow.ellipsis,
        fontSize: 14.sp,
        textColor: iconGreyColor,
      ),
      kHeight15,
      receiverData != null
          ? infoPageCommonGroupList(
              receiverData: receiverData,
            )
          : groupData!.adminsPermissions!
                      .contains(AdminsGroupPermission.viewMembers) &&
                  !groupData.groupAdmins!.contains(firebaseAuth.currentUser?.uid)
              ? zeroMeasureWidget
              : infoPageGroupMembersList(
                  context: context,
                  groupData: groupData,
                )
    ],
  );
}
