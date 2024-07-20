import 'dart:developer';
import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/group_model/group_model.dart';
import 'package:chatbox/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/select_contacts/selected_contacts_show_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/select_user_widgets.dart/contact_single_widget.dart';
import 'package:chatbox/features/presentation/widgets/select_user_widgets.dart/floating_done_navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectContactPage extends StatefulWidget {
  const SelectContactPage({
    super.key,
    this.chatModel,
    this.receiverContactName,
    required this.pageType, this.groupModel, required this.isGroup,
  });
  final ChatModel? chatModel;
  final String? receiverContactName;
  final PageTypeEnum pageType;
  final GroupModel? groupModel;
  final bool isGroup;
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
            TextWidgetCommon(
                text: widget.pageType == PageTypeEnum.sendContactSelectPage
                    ? "Selected Contacts"
                    : widget.pageType == PageTypeEnum.groupMemberSelectPage
                        ? "New Group"
                        : "New Broadcast"),
            widget.pageType == PageTypeEnum.sendContactSelectPage
                ? BlocBuilder<ContactBloc, ContactState>(
                    builder: (context, state) {
                      return TextWidgetCommon(
                        text: "${state.selectedContactList?.length} contacts",
                        fontSize: 12.sp,
                      );
                    },
                  )
                : zeroMeasureWidget,
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.watch<ContactBloc>().state.selectedContactList!.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: smallGreyMediumBoldTextWidget(
                      text:
                          widget.pageType != PageTypeEnum.sendContactSelectPage
                              ? "Added members"
                              : "Selected contacts"),
                )
              : zeroMeasureWidget,
          SelectedContactShowWidget(),
          context.watch<ContactBloc>().state.contactList!.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: smallGreyMediumBoldTextWidget(
                      text:
                          widget.pageType != PageTypeEnum.sendContactSelectPage
                              ? "Add members"
                              : "Select contacts"),
                )
              : zeroMeasureWidget,
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
                List<ContactModel> chatBoxUsersList = [];
                for (var contact in state.contactList!) {
                  if (contact.isChatBoxUser ?? false) {
                    chatBoxUsersList.add(contact);
                  }
                }
                chatBoxUsersList.removeWhere((chatBoxUser) =>
                    chatBoxUser.chatBoxUserId == firebaseAuth.currentUser?.uid);
                if (widget.pageType != PageTypeEnum.sendContactSelectPage) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    itemCount: chatBoxUsersList.length,
                    itemBuilder: (context, index) {
                      final contact = chatBoxUsersList[index];

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
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: state.contactList!.length,
                  itemBuilder: (context, index) {
                    final contact = state.contactList![index];
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
          return FloatingDoneNavigateButton(
            groupModel: widget.groupModel,
            isGroup: widget.isGroup,
            pageType: widget.pageType,
            receiverContactName: widget.receiverContactName ?? '',
            chatModel: widget.chatModel,
            selectedContactList: state.selectedContactList,
          );
        },
      ),
    );
  }
}
