import 'dart:developer';

import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/core/utils/date_provider.dart';
import 'package:chatbox/core/utils/small_common_widgets.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/bloc/status/status_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/select_contacts/select_contact_page.dart';
import 'package:chatbox/features/presentation/widgets/status/build_status_item_widget.dart';
import 'package:chatbox/features/presentation/widgets/status/status_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SelectContactPage(pageType: PageTypeEnum.fromStatusPage, isGroup: false,),));
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
