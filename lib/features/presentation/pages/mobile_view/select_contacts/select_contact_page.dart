import 'dart:developer';

import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/data_sources/user_data/user_data.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:chatbox/features/presentation/bloc/message/message_bloc.dart';
import 'package:chatbox/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectContactPage extends StatefulWidget {
  const SelectContactPage({super.key, required this.chatModel});
  final ChatModel chatModel;
  @override
  State<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  @override
  void initState() {
    super.initState();
    // Clear the selected contacts when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactBloc>().add(ClearListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    log("${context.watch<ContactBloc>().state.contactList?.length}Length");
    if (context.watch<ContactBloc>().state.contactList?.length == 0 ||
        context.watch<ContactBloc>().state.contactList?.length == null) {
      context.read<ContactBloc>().add(GetContactsEvent());
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidgetCommon(text: "Selected Contacts"),
            BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                return TextWidgetCommon(
                  text: "${state.selectedContactList?.length} contacts",
                  fontSize: 12.sp,
                );
              },
            )
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: context
                    .watch<ContactBloc>()
                    .state
                    .selectedContactList!
                    .isNotEmpty
                ? 100.h
                : 0.h,
            child: BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                if (state.selectedContactList == null) {
                  return zeroMeasureWidget;
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SelectContactCircleWidget(
                      contactModel: state.selectedContactList![index],
                    );
                  },
                  separatorBuilder: (context, index) => kWidth5,
                  itemCount: state.selectedContactList!.length,
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                if (state is ContactsErrorState) {
                  return commonErrorWidget(message: state.message);
                }
                if (state is ContactsLoadingState) {
                  return commonAnimationWidget(
                      context: context, isTextNeeded: true, text: "Loading");
                }
                if (state.contactList == null) {
                  return zeroMeasureWidget;
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: state.contactList!.length,
                  itemBuilder: (context, index) {
                    final contact = state.contactList![index];
                    log("${state.selectedContactList?.length.toString()} SelectedList");
                    return ContactSingleWidget(
                      key: ValueKey(contact.userContactNumber),
                      isSelected: state.selectedContactList != null
                          ? state.selectedContactList!.contains(contact)
                          : false,
                      contactModel: contact,
                      contactNameorNumber: contact.userContactName ??
                          contact.userContactNumber ??
                          '',
                    );
                  },
                  separatorBuilder: (context, index) => kHeight2,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              state.selectedContactList != null
                  ? context.read<MessageBloc>().add(
                        ContactMessageSendEvent(
                          contactListToSend: state.selectedContactList!,
                          chatModel: widget.chatModel,
                        ),
                      )
                  : null;
              Navigator.pop(context);
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
                  Icons.arrow_forward_rounded,
                  size: 30.sp,
                  color: kWhite,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ContactSingleWidget extends StatelessWidget {
  const ContactSingleWidget({
    super.key,
    required this.contactNameorNumber,
    required this.contactModel,
    required this.isSelected,
  });
  final String contactNameorNumber;
  final ContactModel contactModel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(contactModel.userContactNumber),
      onTap: () {
        context.read<ContactBloc>().add(SelectUserEvent(contact: contactModel));
      },
      leading: Stack(
        children: [
          selectedUserDataWidget(
            contactModel: contactModel,
          ),
          isSelected
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          darkLinearGradientColorOne,
                          darkLinearGradientColorTwo,
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.done,
                      color: kWhite,
                      size: 20.sp,
                    ),
                  ),
                )
              : zeroMeasureWidget
        ],
      ),
      title: TextWidgetCommon(
        text: contactNameorNumber,
      ),
    );
  }
}

class SelectContactCircleWidget extends StatelessWidget {
  const SelectContactCircleWidget({
    super.key,
    required this.contactModel,
  });
  final ContactModel contactModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(contactModel.userContactNumber),
      children: [
        Stack(
          children: [
            selectedUserDataWidget(
              contactModel: contactModel,
            ),
            Positioned(
              bottom: 0.h,
              right: 0.w,
              child: Container(
                height: 25.h,
                width: 25.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        darkLinearGradientColorOne,
                        darkLinearGradientColorTwo,
                      ],
                    )),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      context
                          .read<ContactBloc>()
                          .add(SelectUserEvent(contact: contactModel));
                    },
                    icon: Icon(
                      Icons.close,
                      color: kWhite,
                      size: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 50.w,
          child: TextWidgetCommon(
            text: contactModel.userContactName ??
                contactModel.userContactNumber ??
                '',
            fontSize: 12.sp,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

BlocBuilder<UserBloc, UserState> selectedUserDataWidget(
    {required ContactModel contactModel}) {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      Stream<UserModel?> userModel = const Stream.empty();
      if (contactModel.chatBoxUserId != null) {
        userModel = UserData.getOneUserDataFromDataBaseAsStream(
          userId: contactModel.chatBoxUserId!,
        );
      }
      return StreamBuilder<UserModel?>(
        stream: userModel,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            commonProfileDefaultIconCircularCotainer(
              context: context,
            );
          }
          return snapshot.data?.userProfileImage != null
              ? Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).popupMenuTheme.color,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            snapshot.data!.userProfileImage!,
                          ))),
                  width: 50.w,
                  height: 50.h,
                )
              : commonProfileDefaultIconCircularCotainer(
                  context: context,
                );
        },
      );
    },
  );
}
