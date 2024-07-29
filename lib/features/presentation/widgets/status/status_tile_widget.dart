import 'package:chatbox/config/bloc_providers/all_bloc_providers.dart';
import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/core/enums/enums.dart';
import 'package:chatbox/core/utils/common_db_functions.dart';
import 'package:chatbox/features/data/models/status_model/status_model.dart';
import 'package:chatbox/features/data/models/user_model/user_model.dart';
import 'package:chatbox/features/presentation/bloc/status/status_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/status/status_pages/status_show_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/file_show_page.dart';
import 'package:chatbox/features/presentation/widgets/common_widgets/text_widget_common.dart';
import 'package:chatbox/features/presentation/widgets/settings/profile_image_selector_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:status_view/status_view.dart';

Widget statusTileWidget({
  required BuildContext context,
  StatusModel? statusModel,
  bool? isCurrentUser = false,
}) {
  return ListTile(
    onTap: () {
      if (statusModel != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StatusShowPage(statusModel: statusModel),
          ),
        );
      }
    },
    leading: Stack(
      children: [
        StreamBuilder<UserModel?>(
            stream: statusModel != null
                ? statusModel.statusUploaderId != null
                    ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                        userId: statusModel.statusUploaderId!)
                    : null
                : null,
            builder: (context, snapshot) {
              return StatusView(
                indexOfSeenStatus: 2,
                numberOfStatus: statusModel != null
                    ? statusModel.statusList != null
                        ? statusModel.statusList!.length
                        : 0
                    : 0,
                radius: 30,
                strokeWidth: 2,
                seenColor: Colors.black,
                unSeenColor: buttonSmallTextColor,
                centerImageUrl: snapshot.data?.userProfileImage ??
                    "https://cdn.pixabay.com/photo/2024/05/26/10/15/bird-8788491_1280.jpg",
              );
            }),
        if (statusModel == null && isCurrentUser!)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                assetSelectorBottomSheet(
                  context: context,
                  firstButtonName: "Image",
                  secondButtonName: "Video",
                  firstButtonAction: () {
                    context.read<StatusBloc>().add(
                          PickStatusEvent(
                            statusModel: statusModel,
                            context: context,
                            statusType: StatusType.image,
                          ),
                        );
                  },
                  firstButtonIcon: Icons.photo,
                  secondButtonIcon: Icons.video_library_outlined,
                  secondButtonAction: () {
                    context.read<StatusBloc>().add(
                          PickStatusEvent(
                              statusType: StatusType.video,
                              context: context,
                              statusModel: statusModel),
                        );
                  },
                );
              },
              child: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      lightLinearGradientColorOne,
                      lightLinearGradientColorTwo
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: kWhite,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          )
      ],
    ),
    title: StreamBuilder<UserModel?>(
        stream: statusModel != null
            ? statusModel.statusUploaderId != null
                ? CommonDBFunctions.getOneUserDataFromDataBaseAsStream(
                    userId: statusModel.statusUploaderId!)
                : null
            : null,
        builder: (context, snapshot) {
          return TextWidgetCommon(
            text: isCurrentUser!
                ? "My status"
                : snapshot.data?.contactName ??
                    snapshot.data?.userName ??
                    'My Status',
            fontSize: 16.sp,
          );
        }),
    trailing: TextWidgetCommon(
      text: !isCurrentUser!
          ? statusModel?.statusList?.last.statusUploadedTime ?? ''
          : "",
      textColor: iconGreyColor,
      fontWeight: FontWeight.normal,
      fontSize: 10.sp,
    ),
  );
}
