import 'package:chatbox/core/constants/colors.dart';
import 'package:chatbox/core/constants/height_width.dart';
import 'package:chatbox/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:chatbox/presentation/widgets/settings/profile_image_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Widget userProfileImageContainerWidget(
//     {required BuildContext context, required double containerRadius}) {
//   return BlocBuilder<UserBloc, UserState>(
//     builder: (context, state) {
//       if (state is ImagePickErrorState) {
//         return Center(
//           child: Text(state.message),
//         );
//       }
//       if (state is CurrentUserLoadedState) {
//         return Container(
//           height: containerRadius.h,
//           width: containerRadius.w,
//           decoration: BoxDecoration(
//             color: Theme.of(context).popupMenuTheme.color,
//             shape: BoxShape.circle,
//             image: DecorationImage(
//               image: NetworkImage(state.currentUserData.userProfileImage!),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: containerRadius >= 160
//               ? Align(
//                   alignment: Alignment.bottomRight,
//                   child: Container(
//                     height: 50.h,
//                     width: 50.h,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(colors: [
//                           darkLinearGradientColorTwo,
//                           darkLinearGradientColorOne,
//                         ])),
//                     child: Center(
//                       child: IconButton(
//                         onPressed: () {
//                           profileImageSelectorBottomSheet(context: context);
//                         },
//                         icon: SvgPicture.asset(
//                           cameraIcon,
//                           height: 30.h,
//                           width: 30.w,
//                           colorFilter: ColorFilter.mode(
//                             kWhite,
//                             BlendMode.srcIn,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               : zeroMeasureWidget,
//         );
//       }
//       return zeroMeasureWidget;
//     },
//   );
// }




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
        return Container(
          height: containerRadius.h,
          width: containerRadius.w,
          decoration: BoxDecoration(
            color: Theme.of(context).popupMenuTheme.color,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(state.currentUserData.userProfileImage!),
              fit: BoxFit.cover,
            ),
          ),
          child: containerRadius >= 160
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 50.h,
                    width: 50.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          darkLinearGradientColorTwo,
                          darkLinearGradientColorOne,
                        ])),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          profileImageSelectorBottomSheet(context: context);
                        },
                        icon: SvgPicture.asset(
                          cameraIcon,
                          height: 30.h,
                          width: 30.w,
                          colorFilter: ColorFilter.mode(
                            kWhite,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : zeroMeasureWidget,
        );
      }
      return zeroMeasureWidget;
    },
  );
}
