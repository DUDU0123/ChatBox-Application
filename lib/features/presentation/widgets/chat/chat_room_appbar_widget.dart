import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/one_to_one_chat_info_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/group/group_pages/group_info_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/features/data/data_sources/user_data/user_data.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_appbar_widget.dart';

Widget oneToOneChatAppBarWidget({
  required ChatModel? chatModel,
  required bool isGroup,
  required String userName,
  required BuildContext context,
  required String receiverID,
}) {
  return StreamBuilder<UserModel?>(
      stream: UserData.getOneUserDataFromDataBaseAsStream(
          userId: chatModel?.receiverID ?? receiverID),
      builder: (context, snapshot) {
        return CommonAppBar(
          onTap: () async {
            if (chatModel == null) {
              return;
            }
            if (chatModel.receiverID == null) {
              return;
            }
            final UserModel? receiverData =
                await CommonDBFunctions.getOneUserDataFromDBFuture(
              userId: chatModel.receiverID!,
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OneToOneChatInfoPage(
                    receiverContactName: userName,
                    receiverData: receiverData,
                  ),
                ));
          },
          userProfileImage: chatModel?.receiverProfileImage,
          userStatus: snapshot.data != null
              ? snapshot.data!.userNetworkStatus != null
                  ? snapshot.data!.userNetworkStatus!
                      ? 'Online'
                      : TimeProvider.getUserLastActiveTime(
                          givenTime: snapshot.data!.lastActiveTime.toString(),
                          context: context,
                        )
                  : TimeProvider.getUserLastActiveTime(
                      givenTime: snapshot.data!.lastActiveTime.toString(),
                      context: context,
                    )
              : 'Offline',
          appBarTitle: userName,
          pageType: isGroup
              ? PageTypeEnum.groupMessageInsidePage
              : PageTypeEnum.oneToOneChatInsidePage,
        );
      });
}

Widget groupChatAppBarWidget({
  required GroupModel? groupModel,
  required bool isGroup,
  required BuildContext context,
}) {
  if (groupModel == null) {
    return const TextWidgetCommon(text: "No Appbar");
  }
  return CommonAppBar(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  GroupInfoPage(
              groupData: groupModel,
            ),
          ));
    },
    userProfileImage: groupModel.groupProfileImage,
    appBarTitle: groupModel.groupName ?? 'Group name',
    pageType: PageTypeEnum.groupMessageInsidePage,
  );
}
