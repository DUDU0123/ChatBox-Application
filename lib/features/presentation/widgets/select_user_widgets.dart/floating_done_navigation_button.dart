import 'dart:io';

import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/snackbar.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/presentation/bloc/group/group_bloc.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/group/group_pages/group_details_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingDoneNavigateButton extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        switch (pageType) {
          case PageTypeEnum.sendContactSelectPage:
            selectedContactList != null
                ? receiverContactName != null
                    ? context.read<MessageBloc>().add(
                          ContactMessageSendEvent(
                            isGroup: isGroup,
                            groupModel: groupModel,
                            receiverID: chatModel?.receiverID,
                            receiverContactName: receiverContactName!,
                            contactListToSend: selectedContactList!,
                            chatModel: chatModel,
                          ),
                        )
                    : null
                : null;
            Navigator.pop(context);
            break;
          case PageTypeEnum.groupMemberSelectPage:
            selectedContactList != null
                ? selectedContactList!.length >= 2
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailsAddPage(
                            selectedGroupMembers: selectedContactList!,
                          ),
                        ),
                      )
                    : commonSnackBarWidget(
                        contentText: "Select atleast 2 members",
                        context: context,
                      )
                : commonSnackBarWidget(
                    contentText: "Select atleast 2 members",
                    context: context,
                  );
            break;
          case PageTypeEnum.broadcastMembersSelectPage:
            break;
          case PageTypeEnum.groupDetailsAddPage:
            final String? currentUser = firebaseAuth.currentUser?.uid;
            if (currentUser == null) {
              return;
            }
            List<String> selectUsersID = [];
            for (var user in selectedContactList!) {
              if (user.chatBoxUserId != null) {
                selectUsersID.add(user.chatBoxUserId!);
              }
            }
            List<MembersGroupPermission> memberPermissions = filterPermissions(
              context.read<GroupBloc>().state.memberPermissions,
            );
            List<AdminsGroupPermission> adminPermissions = filterPermissions(
              context.read<GroupBloc>().state.adminPermissions,
            );
            GroupModel newGroupData = GroupModel(
              groupCreatedAt: DateTime.now().toString(),
              groupName: groupName,
              groupAdmins: [currentUser],
              groupMembers: [currentUser, ...selectUsersID],
              adminsPermissions: adminPermissions,
              membersPermissions: memberPermissions,
            );
            groupName != null
                ? groupName!.isNotEmpty
                    ? context.read<GroupBloc>().add(
                          CreateGroupEvent(
                            context: context,
                            newGroupData: newGroupData,
                            groupProfileImage: pickedGroupImageFile,
                          ),
                        )
                    : commonSnackBarWidget(
                        contentText: "Enter group name",
                        context: context,
                      )
                : commonSnackBarWidget(
                    contentText: "Enter group name",
                    context: context,
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
            icon ?? Icons.arrow_forward_rounded,
            size: 30.sp,
            color: kWhite,
          ),
        ),
      ),
    );
  }
}
