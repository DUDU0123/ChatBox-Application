import 'dart:developer';

import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/chat_model/chat_model.dart';
import 'package:chatbox/features/data/models/contact_model/contact_model.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatbox/features/presentation/bloc/status/status_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/chat/chat_home_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/settings/user_details/user_profile_container_widget.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/status/build_status_item_widget.dart';
import 'package:chatbox/features/presentation/widgets/status/status_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StatusShowPage extends StatelessWidget {
  StatusShowPage({super.key, required this.statusModel});
  final StatusModel statusModel;
  final StoryController controller = StoryController();
  final ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (statusModel.statusList != null &&
              statusModel.statusList!.isNotEmpty)
            StoryView(
              onComplete: () {
                Navigator.pop(context);
              },
              onVerticalSwipeComplete: (p0) {
                Navigator.pop(context);
              },
              onStoryShow: (s, i) {
                currentIndexNotifier.value = i;
              },
              storyItems: buildStatusItems(
                controller: controller,
                statusModel: statusModel,
                context: context,
              ),
              controller: controller,
            ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<int>(
              valueListenable: currentIndexNotifier,
              builder: (context, currentIndex, _) {
                log(statusModel.statusList![currentIndex].statusUploadedTime
                    .toString());
                return StreamBuilder<UserModel?>(
                    stream: statusModel.statusUploaderId != null
                        ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                            userId: statusModel.statusUploaderId!)
                        : null,
                    builder: (context, snapshot) {
                      return statusAppBar(
                        context: context,
                        statusUploaderImage: snapshot.data?.userProfileImage,
                        userName: statusModel.statusUploaderId ==
                                firebaseAuth.currentUser?.uid
                            ? "My status"
                            : snapshot.data?.contactName ??
                                snapshot.data?.userName ??
                                '',
                        howHours: statusModel.statusList != null
                            ? TimeProvider.getRelativeTime(statusModel
                                .statusList![currentIndex].statusUploadedTime
                                .toString())
                            : '',
                        deleteMethod: () {
                          final uploadedStatusId = statusModel
                              .statusList?[currentIndex].uploadedStatusId;
                          statusModel.statusId != null
                              ? uploadedStatusId != null
                                  ? context
                                      .read<StatusBloc>()
                                      .add(StatusDeleteEvent(
                                        statusModelId: statusModel.statusId!,
                                        uploadedStatusId: uploadedStatusId,
                                      ))
                                  : null
                              : null;
                          // Remove the deleted status from the list
                          statusModel.statusList!.removeAt(currentIndex);
                        },
                        shareMethod: () {
                          statusModel.statusList != null
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectContactPage(
                                      isGroup: false,
                                      pageType: PageTypeEnum.toSendPage,
                                      uploadedStatusModel:
                                          statusModel.statusList![currentIndex],
                                    ),
                                  ))
                              : null;
                        },
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ListAllChatMembersPage extends StatelessWidget {
  const ListAllChatMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidgetCommon(text: "Select Contact to Send"),
      ),
      body: StreamBuilder<List<ContactModel>?>(
          stream: CommonDBFunctions.getContactsCollection(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return commonErrorWidget(message: "Something went wrong");
            }
            final contactList = snapshot.data;
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => kHeight10,
              itemBuilder: (context, index) {
                final contact = contactList![index];
                return ListTile(
                  leading: contact.userProfilePhotoOnChatBox != null
                      ? Container(
                          width: 50,
                          height: 50,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.sp),
                            child: Image.network(
                              fit: BoxFit.cover,
                              contact.userProfilePhotoOnChatBox!,
                              errorBuilder: (context, error, stackTrace) {
                                return nullImageReplaceWidget(
                                  containerRadius: 50,
                                  context: context,
                                );
                              },
                            ),
                          ),
                        )
                      : nullImageReplaceWidget(
                          containerRadius: 40, context: context),
                  title: TextWidgetCommon(
                    text: contact.userContactName ?? '',
                  ),
                );
              },
            );
          }),
    );
  }
}
