import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/snackbar.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_room_page.dart';
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
  });

  final ChatModel? chatModel;
  final List<ContactModel>? selectedContactList;
  final String? receiverContactName;
  final PageTypeEnum pageType;
  final IconData? icon;
  final String? groupName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (pageType) {
          case PageTypeEnum.sendContactSelectPage:
            selectedContactList != null
                ? chatModel != null
                    ? receiverContactName != null
                        ? context.read<MessageBloc>().add(
                              ContactMessageSendEvent(
                                receiverID: chatModel!.receiverID!,
                                receiverContactName: receiverContactName!,
                                contactListToSend: selectedContactList!,
                                chatModel: chatModel!,
                              ),
                            )
                        : null
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
            groupName != null
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomPage(
                        userName: groupName ?? '',
                        isGroup: true,
                      ),
                    ),
                  )
                : null;
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
