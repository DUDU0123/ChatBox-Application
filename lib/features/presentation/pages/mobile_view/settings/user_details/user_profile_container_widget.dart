import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/features/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:chatbox/features/presentation/pages/mobile_view/settings/user_details/camera_icon_button.dart';
import 'package:chatbox/features/presentation/widgets/settings/profile_image_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget userProfileImageContainerWidget(
    {required BuildContext context, required double containerRadius}) {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is ImagePickErrorState) {
        return Center(
          child: Text(state.message),
        );
      }
      if (state is CurrentUserLoadedState) {
        return state.currentUserData.userProfileImage != null
            ? Container(
                height: containerRadius.h,
                width: containerRadius.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).popupMenuTheme.color,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        state.currentUserData.userProfileImage!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: containerRadius >= 160
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: CameraIconButton(onPressed: () {
                          profileImageSelectorBottomSheet(context: context);
                        },),
                      )
                    : zeroMeasureWidget,
              )
            : nullImageReplaceWidget(
                containerRadius: containerRadius,
                context: context,
              );
      }
      return zeroMeasureWidget;
    },
  );
}

Widget nullImageReplaceWidget(
    {required double containerRadius, required BuildContext context}) {
  return Stack(
    children: [
      Container(
        height: containerRadius.h,
        width: containerRadius.w,
        decoration: BoxDecoration(
          color: Theme.of(context).popupMenuTheme.color,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                contact,
                width: 100.w,
                height: 100.h,
              ),
            ),
            containerRadius >= 160
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: CameraIconButton(
                      onPressed: () {
                        profileImageSelectorBottomSheet(context: context);
                      },
                    ),
                  )
                : zeroMeasureWidget,
          ],
        ),
      ),
    ],
  );
}