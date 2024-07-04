import 'dart:developer';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/invite_app_function.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatbox/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/messaging_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/user_tile_name_about_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectContactToChat extends StatelessWidget {
  const SelectContactToChat({super.key});

  void chatOpen(
      {required ContactModel contactModel, required BuildContext context}) {
    context
        .read<ChatBloc>()
        .add(CreateANewChatEvent(contactModel: contactModel));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagingPage(
          isGroup: false,
          userName: contactModel.userContactName ??
              contactModel.userContactNumber.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidgetCommon(text: "Select Contact"),
            TextWidgetCommon(
              text:
                  "${context.watch<ContactBloc>().state.contactList.length} contacts",
              fontSize: 12.sp,
              textColor: iconGreyColor,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                log("Length: Contactpage: ${state.contactList.length}");
                if (state is ContactsFetchErrorState) {
                  return emptyShowWidget(context: context, text: "No contacts");
                }
                if (state is ContactsLoadingState) {
                  return commonAnimationWidget(
                    context: context,
                    isTextNeeded: true,
                    text: "Loading contacts...",
                    fontSize: 12.sp,
                  );
                }
                state.contactList.sort((a, b) {
                  if (a.isChatBoxUser! && !b.isChatBoxUser!) {
                    return -1; // a comes before b
                  } else if (!a.isChatBoxUser! && b.isChatBoxUser!) {
                    return 1; // b comes before a
                  } else {
                    return 0; // a and b are equivalent
                  }
                });
                return state.contactList.isEmpty
                    ? emptyShowWidget(context: context, text: "No Contacts")
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          if (state.contactList[index].isChatBoxUser != null) {
                            state.contactList[index].isChatBoxUser!
                                ? log(
                                    "Id: ${state.contactList[index].chatBoxUserId} \n name: ${state.contactList[index].userContactName} \n Imageee: ${state.contactList[index].userProfilePhotoOnChatBox}",
                                  )
                                : null;
                          }
                          return UserTileWithNameAndAboutAndProfileImage(
                            onTap: () {
                              if (state.contactList[index].isChatBoxUser !=
                                  null) {
                                state.contactList[index].isChatBoxUser!
                                    ? chatOpen(
                                        contactModel: state.contactList[index],
                                        context: context,
                                      )
                                    : null;
                              }
                            },
                            trailing:
                                state.contactList[index].isChatBoxUser != null
                                    ? !state.contactList[index].isChatBoxUser!
                                        ? TextButton(
                                            onPressed: () async {
                                              //create the link to send as invitation
                                              // write the logic to send an invitation to install and use the application
                                              await inviteToChatBoxApp();
                                            },
                                            child: TextWidgetCommon(
                                              text: "Invite",
                                              textColor: buttonSmallTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.sp,
                                            ),
                                          )
                                        : zeroMeasureWidget
                                    : zeroMeasureWidget,
                            userName:
                                state.contactList[index].userContactName ?? '',
                            userAbout: state.contactList[index].userAbout ??
                                state.contactList[index].userContactNumber,
                            userPicture: state
                                .contactList[index].userProfilePhotoOnChatBox,
                          );
                        },
                        separatorBuilder: (context, index) => kHeight5,
                        itemCount: state.contactList.length,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
