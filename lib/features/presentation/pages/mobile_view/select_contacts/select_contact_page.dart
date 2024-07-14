import 'dart:developer';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/presentation/bloc/contact/contact_bloc.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/select_user_widgets.dart/contact_single_widget.dart';
import 'package:chatbox/features/presentation/widgets/select_user_widgets.dart/floating_done_navigation_button.dart';
import 'package:chatbox/features/presentation/widgets/select_user_widgets.dart/select_contact_circle_widget.dart';
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
            chatModel: widget.chatModel,
            selectedContactList: state.selectedContactList,
          );
        },
      ),
    );
  }
}
