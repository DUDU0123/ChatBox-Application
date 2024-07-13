import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/features/data/data_sources/user_data/user_data.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';

Widget chatRoomAppBarWidget({
  required ChatModel chatModel,
  required bool isGroup,
  required String userName,
}) {
  return StreamBuilder<UserModel?>(
      stream: UserData.getOneUserDataFromDataBaseAsStream(
          userId: chatModel.receiverID ?? ''),
      builder: (context, snapshot) {
        return CommonAppBar(
          userProfileImage: chatModel.receiverProfileImage,
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
