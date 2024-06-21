import 'dart:developer';

import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/presentation/bloc/contact/contact_bloc.dart';
import 'package:chatbox/presentation/pages/mobile_view/chat/messaging_page.dart';
import 'package:chatbox/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/presentation/widgets/common_widgets/user_tile_name_about_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectContactToChat extends StatelessWidget {
  const SelectContactToChat({super.key});

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
                  return emptyShowWidget(context: context, text: state.message);
                }
                if (state is ContactsLoadingState) {
                  return commonAnimationWidget(
                    context: context,
                    isTextNeeded: true,
                    text: "Loading contacts...",
                    fontSize: 12.sp,
                  );
                }
                return state.contactList.isEmpty
                    ? emptyShowWidget(context: context, text: "No Contacts")
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          return UserTileWithNameAndAboutAndProfileImage(
                            onTap: () {
                              if (state.contactList[index].isChatBoxUser !=
                                  null) {
                                state.contactList[index].isChatBoxUser!
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MessagingPage(
                                            isGroup: false,
                                            userName: state.contactList[index]
                                                    .userContactName ??
                                                '',
                                          ),
                                        ),
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
                                              // final r = await Share.share(
                                              //     'We are excited to invite you to download and install ChatBox, your ultimate chat application, now available on the Amazon Appstore! ChatBox offers a seamless and engaging communication experience with its user-friendly interface, innovative features, and robust security. Connect with friends, family, and colleagues like never before. Don’t miss out—visit the Amazon Appstore today and make ChatBox your go-to app for all your messaging needs!');
                                              // print(r);
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
