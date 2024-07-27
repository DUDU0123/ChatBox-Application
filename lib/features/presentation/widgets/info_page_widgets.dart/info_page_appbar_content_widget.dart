import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/info_page_widgets.dart/info_page_small_widgets.dart';
import 'package:flutter/material.dart';

Widget infoPageAppBarContentWidget({
  required BuildContext context,
  required UserModel? receiverData,
  required GroupModel? groupData,
  required bool isGroup,
  required String? receiverContactName,
}) {
  return Row(
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
      receiverData?.userProfileImage != null && !isGroup
          ? userProfileImageShowWidget(
              context: context, imageUrl: receiverData!.userProfileImage!)
          : groupData?.groupProfileImage != null && isGroup
              ? StreamBuilder<GroupModel?>(
                  stream: CommonDBFunctions.getOneGroupDataByStream(
                    userID: firebaseAuth.currentUser!.uid,
                    groupID: groupData?.groupID ?? '',
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return nullImageReplaceWidget(
                        containerRadius: 45,
                        context: context,
                      );
                    }
                    if (snapshot.data!.groupProfileImage == null) {
                      return nullImageReplaceWidget(
                        containerRadius: 45,
                        context: context,
                      );
                    }
                    return userProfileImageShowWidget(
                      context: context,
                      imageUrl: snapshot.data!.groupProfileImage!,
                    );
                  })
              : nullImageReplaceWidget(
                  containerRadius: 45,
                  context: context,
                ),
      kWidth2,
      Expanded(
        child: StreamBuilder<GroupModel?>(
            stream: isGroup
                ? CommonDBFunctions.getOneGroupDataByStream(
                    userID: firebaseAuth.currentUser!.uid,
                    groupID: groupData?.groupID ?? '',
                  )
                : null,
            builder: (context, snapshot) {
              return TextWidgetCommon(
                text: !isGroup
                    ? receiverContactName ?? receiverData?.userName ?? ''
                    : snapshot.data?.groupName ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              );
            }),
      )
    ],
  );
}
