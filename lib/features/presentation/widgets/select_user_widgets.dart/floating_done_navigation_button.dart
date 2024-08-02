import 'dart:io';

import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/database_name_constants.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/contact_methods.dart';
import 'package:chatbox/core/utils/group_methods.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/core/utils/snackbar.dart';
import 'package:chatbox/core/utils/status_methods.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/data/models/message_model/message_model.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/data/models/status_model/uploaded_status_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/bloc/group/group_bloc.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/group/group_pages/group_details_add_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingDoneNavigateButton extends StatefulWidget {
  const FloatingDoneNavigateButton({
    super.key,
    this.chatModel,
    this.selectedContactList,
    this.receiverContactName,
    required this.pageType,
    this.icon,
    this.groupName,
    this.pickedGroupImageFile,
    this.groupModel,
    required this.isGroup,
    this.uploadedStatusModel,
    this.statusModel,
    this.uploadedStatusModelID,
  });

  final ChatModel? chatModel;
  final List<ContactModel>? selectedContactList;
  final String? receiverContactName;
  final PageTypeEnum pageType;
  final IconData? icon;
  final String? groupName;
  final File? pickedGroupImageFile;
  final GroupModel? groupModel;
  final bool isGroup;
  final UploadedStatusModel? uploadedStatusModel;
  final StatusModel? statusModel;
  final String? uploadedStatusModelID;

  @override
  State<FloatingDoneNavigateButton> createState() =>
      _FloatingDoneNavigateButtonState();
}

class _FloatingDoneNavigateButtonState
    extends State<FloatingDoneNavigateButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final messageBloc = context.read<MessageBloc>();

        switch (widget.pageType) {
          case PageTypeEnum.sendContactSelectPage:
            ContactMethods.sendSelectedContactMessage(
              selectedContactList: widget.selectedContactList,
              receiverContactName: widget.receiverContactName,
              context: context,
              isGroup: widget.isGroup,
              groupModel: widget.groupModel,
              chatModel: widget.chatModel,
            );
            break;
          case PageTypeEnum.groupMemberSelectPage:
            GroupMethods
                .selectGroupMembersOnCreationAndSendToDetailsAddPageMethod(
              selectedContactList: widget.selectedContactList,
              context: context,
            );
            break;

          case PageTypeEnum.groupInfoPage:
            GroupMethods.updateGroupMembersAfterCreationMethod(
              selectedContactList: widget.selectedContactList,
              groupModel: widget.groupModel,
              context: context,
            );
            break;

          case PageTypeEnum.toSendPage:
            final val = await fireStore
                .collection(usersCollection)
                .doc(firebaseAuth.currentUser?.uid)
                .collection(statusCollection)
                .doc(widget.statusModel?.statusId)
                .get();
            final statusMOdell = StatusModel.fromJson(map: val.data()!);
            final sendingStatus = statusMOdell.statusList?.firstWhere(
                (status) =>
                    status.uploadedStatusId == widget.uploadedStatusModelID);

            StatusMethods.shareStatusToAnyChat(
              selectedContactList: widget.selectedContactList,
              uploadedStatusModel: sendingStatus,
              messageBloc: messageBloc,
            );
            if (mounted) {
              Navigator.pop(context);
            }
            break;
          case PageTypeEnum.broadcastMembersSelectPage:
            final currentUserId = firebaseAuth.currentUser?.uid;
            if (currentUserId != null && widget.selectedContactList != null) {
              List<String> selectUsersID = [];
              for (var user in widget.selectedContactList!) {
                if (user.chatBoxUserId != null) {
                  selectUsersID.add(user.chatBoxUserId!);
                }
              }
              GroupModel newBroadCast = GroupModel(
                  groupID: DateTime.now().millisecondsSinceEpoch.toString(),
                  createdBy: currentUserId,
                  isIncomingMessage: false,
                  groupCreatedAt: DateTime.now().toString(),
                  groupDescription: null,
                  groupAdmins: [currentUserId],
                  adminsPermissions: const [
                    AdminsGroupPermission.addMembers,
                    AdminsGroupPermission.editGroupSettings,
                    AdminsGroupPermission.viewMembers,
                    AdminsGroupPermission.sendMessages,
                    AdminsGroupPermission.approveMembers,
                  ],
                  isMuted: false,
                  membersPermissions: const [],
                  groupMembers: [currentUserId, ...selectUsersID]);
              await fireStore
                  .collection(usersCollection)
                  .doc(currentUserId)
                  .collection(groupsCollection)
                  .add(newBroadCast.toJson());
            }

            break;
          case PageTypeEnum.groupDetailsAddPage:
            GroupMethods.groupDetailsAddOnCreationMethod(
              context: context,
              selectedContactList: widget.selectedContactList,
              groupName: widget.groupName,
              pickedGroupImageFile: widget.pickedGroupImageFile,
            );
            break;
          default:
        }
      },
      child: Container(
        height: 50.h,
        width: 60.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            darkLinearGradientColorOne,
            darkLinearGradientColorTwo,
          ]),
          borderRadius: BorderRadius.circular(15.sp),
        ),
        child: Center(
          child: Icon(
            widget.icon ?? Icons.arrow_forward_rounded,
            size: 30.sp,
            color: kWhite,
          ),
        ),
      ),
    );
  }
}
